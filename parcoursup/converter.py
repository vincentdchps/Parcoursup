from __future__ import annotations
import json
import os


def rename_keys(obj, renames: dict[str, str]):
	if isinstance(obj, dict):
		return {
			renames.get(key, key): rename_keys(value, renames)
			for key, value in obj.items()
		}
	if isinstance(obj, list):
		return [rename_keys(value, renames) for value in obj]
	return obj


def flatten_dictionary(dictionary: dict, key_prefix: str = "") -> dict:
	flattened_dictionary = {}
	for key, value in dictionary.items():
		new_key = f"{key_prefix}{key}"
		if isinstance(value, dict):
			flattened_dictionary.update(flatten_dictionary(value, f"{new_key}_"))
		else:
			flattened_dictionary[new_key] = value
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
):
	obj = []
	for json_file_path in json_file_paths:
		with open(json_file_path, "r", encoding="utf-8") as file:
			data = json.load(file)
			if isinstance(data, list):
				obj.extend(data)
			else:
				obj.append(data)
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
	for key in keys:
		column_values = [row.get(key) for row in flattened_obj]
		mysql_type = determine_mysql_type(column_values)
		if mysql_type == "ERROR":
			raise ValueError(f"Error determining MySQL type for column '{key}'")
		if mysql_type != "NULL":
			valid_keys.append(key)
			valid_values = [value for value in column_values if value is not None]
			has_null = len(valid_values) < len(column_values)
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
					column_definition += f" CHECK ({key} >= 0 AND {key} <= 100)"
				elif counts and is_integer and minimum_value >= 0:
					column_definition += f" CHECK ({key} >= 0)"
			column_definitions.append(column_definition)
	file_index = 1
	insert_count = 0
	file = open(mysql_file_path, "w", encoding="utf-8")
	file.write(f"CREATE DATABASE IF NOT EXISTS {database_name};\n")
	file.write(f"USE {database_name};\n")
	file.write(f"DROP TABLE IF EXISTS {table_name};\n")
	file.write(f"CREATE TABLE IF NOT EXISTS {table_name} (\n")
	file.write(",\n".join(column_definitions))
	if primary_keys:
		file.write(f",\n\tPRIMARY KEY ({", ".join(primary_keys)})")
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
	file.write(f"OPTIMIZE TABLE {table_name};\n")
	file.write("COMMIT;")
	file.close()
