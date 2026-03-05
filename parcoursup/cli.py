from __future__ import annotations
import argparse

from .config import Config
from .converter import convert_json_to_mysql


def run(config: Config) -> None:
	convert_json_to_mysql(
		config.json_file_paths,
		config.mysql_file_path,
		config.database_name,
		config.table_name,
		config.renames,
		config.primary_keys,
		config.not_null,
		config.percentages,
		config.counts,
	)


def main() -> None:
	arg_parser = argparse.ArgumentParser(description="Converts JSON to MySQL.")
	arg_parser.add_argument(
		"-i",
		"--input",
		nargs="+",
		default=["parcoursup.json"],
		help="Path(s) to the input `.json` file(s). Default: `parcoursup.json`.",
	)
	arg_parser.add_argument(
		"-o",
		"--output",
		default="parcoursup.sql",
		help="Path to the output `.sql` file. Default: `parcoursup.sql`.",
	)
	arg_parser.add_argument(
		"-d",
		"--database",
		default="parcoursup",
		help="Name of the MySQL database. Default: `parcoursup`.",
	)
	arg_parser.add_argument(
		"-t",
		"--table",
		default="parcoursup",
		help="Name of the MySQL table. Default: `parcoursup`.",
	)
	arg_parser.add_argument(
		"-r",
		"--rename",
		nargs="+",
		help="Rename keys. Use key:new_key.",
	)
	arg_parser.add_argument(
		"-p",
		"--primary",
		nargs="+",
		help="Primary keys.",
	)
	arg_parser.add_argument(
		"-n",
		"--not-null",
		action="store_true",
		help="Set keys with non-null values as NOT NULL.",
	)
	arg_parser.add_argument(
		"-P",
		"--percentages",
		action="store_true",
		help="Checks for percentages (0 to 100).",
	)
	arg_parser.add_argument(
		"-C",
		"--counts",
		action="store_true",
		help="Checks for counts (>= 0).",
	)
	args = arg_parser.parse_args()
	config = Config(args)
	run(config)


if __name__ == "__main__":
	main()
