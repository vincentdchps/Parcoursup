from __future__ import annotations
import json
import os


def select_entries(
	entries: list,
	range_start: int | None,
	range_end: int | None,
	first: int | None,
	last: int | None,
) -> list:
	entries_length = len(entries)
	if range_start is not None and range_end is not None:
		if range_start <= range_end and range_start < entries_length:
			return entries[range_start : min(range_end + 1, entries_length)]
	elif first is not None:
		if first > 0:
			return entries[0 : min(first, entries_length)]
	elif last is not None:
		if last > 0:
			start = max(0, entries_length - last)
			return entries[start:]
	return entries


def rename_keys(obj, renames: dict[str, str]):
	if isinstance(obj, dict):
		return {
			renames.get(key, key): rename_keys(value, renames)
			for key, value in obj.items()
		}
	if isinstance(obj, list):
		return [rename_keys(value, renames) for value in obj]
	return obj


def cast(value):
	if isinstance(value, float) and value.is_integer():
		return int(value)
	if isinstance(value, str):
		if len(value) > 1 and value.startswith("0") and not value.startswith("0."):
			return value
		if len(value) > 2 and value.startswith("-0") and not value.startswith("-0."):
			return value
		try:
			return int(value)
		except ValueError:
			if not set(value).issubset(set("-+.0123456789")):
				return value
			try:
				float_value = float(value)
				if float_value.is_integer():
					return int(float_value)
				return float_value
			except ValueError:
				pass
	return value


def flatten_dictionary(dictionary: dict, key_prefix: str = "") -> dict:
	flattened_dictionary = {}
	for key, value in dictionary.items():
		new_key = f"{key_prefix}{key}"
		if isinstance(value, dict):
			flattened_dictionary.update(flatten_dictionary(value, f"{new_key}_"))
		else:
			flattened_dictionary[new_key] = cast(value)
	return flattened_dictionary


def get_optimal_string_type(minimum_length: int, maximum_length: int) -> str:
	if minimum_length == maximum_length:
		return f"CHAR({maximum_length})"
	"""
	for exponent in range(1, 9):
		optimal_length = (2**exponent) - 1
	"""
	for exponent in range(1, 8):
		optimal_length = 2**exponent
		if maximum_length <= optimal_length:
			return f"VARCHAR({optimal_length})"
	if maximum_length <= 255:
		return f"VARCHAR({255})"
	return "TEXT"


def get_optimal_integer_type(minimum_value: int, maximum_value: int) -> str:
	if minimum_value >= -128 and maximum_value <= 127:
		return "TINYINT"  # 8 bits
	if minimum_value >= -32768 and maximum_value <= 32767:
		return "SMALLINT"  # 16 bits
	if minimum_value >= -2147483648 and maximum_value <= 2147483647:
		return "INT"  # 32 bits
	return "BIGINT"  # 64 bits


def determine_mysql_type(values: list) -> str:
	valid_values = [value for value in values if value is not None]
	if not valid_values:
		return "NULL"
	data_types = {type(value) for value in valid_values}
	if str in data_types:
		string_lengths = [len(str(value)) for value in valid_values]
		return get_optimal_string_type(min(string_lengths), max(string_lengths))
	if float in data_types:
		return "FLOAT"
	if int in data_types:
		integer_values = [int(value) for value in valid_values]
		return get_optimal_integer_type(min(integer_values), max(integer_values))
	return "ERROR"


def create_insert_statement(table_name: str, keys: list, row: dict) -> str:
	formatted_values = []
	for key in keys:
		value = row.get(key)
		if value is None:
			formatted_values.append("NULL")
		elif isinstance(value, str):
			escaped_string = value.replace("'", "''")
			formatted_values.append(f"'{escaped_string}'")
		else:
			formatted_values.append(str(value))
	values_string = ", ".join(formatted_values)
	return f"INSERT INTO {table_name} VALUES ({values_string});\n"


def check_functional_dependencies(file, fds_path: str, table_name: str) -> None:
	with open(fds_path, "r", encoding="utf-8") as fds_file:
		for line in fds_file:
			line = line.strip().replace("`", "").replace("$", "")
			if not line:
				continue
			delimiter = None
			if "→" in line:
				delimiter = "→"
			elif "->" in line:
				delimiter = "->"
			elif "\\to" in line:
				delimiter = "\\to"
			elif "\\rightarrow" in line:
				delimiter = "\\rightarrow"
			if not delimiter:
				continue
			left, right = line.split(delimiter, 1)
			left_columns = [
				column.strip() for column in left.split(",") if column.strip()
			]
			right_columns = [
				column.strip() for column in right.split(",") if column.strip()
			]
			if not left_columns or not right_columns:
				continue
			left_string = ", ".join(left_columns)
			right_string = ", ".join(right_columns)
			having_clauses = " OR ".join(
				f"COUNT(DISTINCT {column}) > 1" for column in right_columns
			)
			file.write("SELECT\n")
			file.write(f"\t'{left_string} → {right_string}' AS FD,\n")
			file.write("\tCASE\n")
			file.write("\t\tWHEN EXISTS (\n")
			file.write("\t\t\tSELECT 1\n")
			file.write(f"\t\t\tFROM {table_name}\n")
			file.write(f"\t\t\tGROUP BY {left_string}\n")
			file.write(f"\t\t\tHAVING {having_clauses}\n")
			file.write("\t\t) THEN 'Invalid'\n")
			file.write("\t\tELSE 'Valid'\n")
			file.write("\tEND AS Status;\n\n")
			select_clauses = list(left_columns)
			for column in right_columns:
				select_clauses.append(f"COUNT(DISTINCT {column}) AS {column}_count")
			for column in right_columns:
				select_clauses.append(
					f"GROUP_CONCAT(DISTINCT {column}) AS {column}_values"
				)
			having_clauses = [f"{column}_count > 1" for column in right_columns]
			select_sql = ",\n\t".join(select_clauses)
			having_sql = " OR ".join(having_clauses)
			file.write("SELECT\n")
			file.write(f"\t{select_sql}\n")
			file.write(f"FROM {table_name}\n")
			file.write(f"GROUP BY {left_string}\n")
			file.write(f"HAVING {having_sql};\n\n")


def convert_json_to_mysql(
	json_file_paths: list[str],
	mysql_file_path: str,
	database_name: str,
	table_name: str,
	renames: dict[str, str],
	primary_keys: list[str],
	not_null: bool,
	percentages: bool,
	counts: bool,
	split: int,
	print_mode: bool,
	range_start: int | None,
	range_end: int | None,
	first: int | None,
	last: int | None,
	fds: str | None,
):
	if not json_file_paths:
		if fds:
			with open(mysql_file_path, "w", encoding="utf-8") as file:
				file.write(f"USE {database_name};\n")
				check_functional_dependencies(file, fds, table_name)
		return
	obj = []
	for json_file_path in json_file_paths:
		with open(json_file_path, "r", encoding="utf-8") as file:
			data = json.load(file)
			if isinstance(data, list):
				obj.extend(data)
			else:
				obj.append(data)
	obj = select_entries(obj, range_start, range_end, first, last)
	if renames:
		obj = rename_keys(obj, renames)
	flattened_obj = [flatten_dictionary(row) for row in obj]
	keys = []
	for row in flattened_obj:
		for key in row.keys():
			if key not in keys:
				keys.append(key)
	valid_keys = []
	column_definitions = []
	non_null_keys = []
	percentage_keys = []
	count_keys = []
	for key in keys:
		column_values = [row.get(key) for row in flattened_obj]
		mysql_type = determine_mysql_type(column_values)
		if mysql_type == "ERROR":
			raise ValueError(f"Error determining MySQL type for column '{key}'")
		if mysql_type != "NULL":
			valid_keys.append(key)
			valid_values = [value for value in column_values if value is not None]
			has_null = len(valid_values) < len(column_values)
			if not has_null:
				non_null_keys.append(key)
			column_definition = f"\t{key} {mysql_type}"
			if not_null and not has_null:
				column_definition += " NOT NULL"
			is_numeric = valid_values and all(
				isinstance(value, (int, float)) and not isinstance(value, bool)
				for value in valid_values
			)
			is_integer = valid_values and all(
				isinstance(value, int) and not isinstance(value, bool)
				for value in valid_values
			)
			if is_numeric:
				minimum_value = min(valid_values)
				maximum_value = max(valid_values)
				if percentages and minimum_value >= 0 and maximum_value <= 100:
					percentage_keys.append(key)
					column_definition += f" CHECK ({key} >= 0 AND {key} <= 100)"
				elif counts and is_integer and minimum_value >= 0:
					count_keys.append(key)
					column_definition += f" CHECK ({key} >= 0)"
			column_definitions.append(column_definition)
	if print_mode:
		print(f"Non-null: {', '.join(non_null_keys)}\n")
		print(f"Percentages: {', '.join(percentage_keys)}\n")
		print(f"Counts: {', '.join(count_keys)}\n")
		return
	file_index = 1
	insert_count = 0
	file = open(mysql_file_path, "w", encoding="utf-8")
	file.write(f"CREATE DATABASE IF NOT EXISTS {database_name};\n")
	file.write(f"USE {database_name};\n")
	file.write(f"DROP TABLE IF EXISTS {table_name};\n")
	file.write(f"CREATE TABLE IF NOT EXISTS {table_name} (\n")
	file.write(",\n".join(column_definitions))
	if primary_keys:
		file.write(f",\n\tPRIMARY KEY ({', '.join(primary_keys)})")
	file.write("\n);\n")
	for row in flattened_obj:
		if split > 0 and insert_count >= split:
			file.write(f"OPTIMIZE TABLE {table_name};\n")
			file.write("COMMIT;\n")
			file.close()
			root, ext = os.path.splitext(mysql_file_path)
			if file_index == 1:
				os.replace(mysql_file_path, f"{root}_{file_index:03d}{ext}")
			file_index += 1
			insert_count = 0
			next_mysql_file_path = f"{root}_{file_index:03d}{ext}"
			file = open(next_mysql_file_path, "w", encoding="utf-8")
			file.write(f"USE {database_name};\n")
		insert_statement = create_insert_statement(table_name, valid_keys, row)
		file.write(insert_statement)
		insert_count += 1
	if fds:
		check_functional_dependencies(file, fds, table_name)
	file.write(f"OPTIMIZE TABLE {table_name};\n")
	file.write("COMMIT;")
	file.close()
