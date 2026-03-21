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
		config.split,
		config.print_mode,
		config.range_start,
		config.range_end,
		config.first,
		config.last,
		config.fds,
		config.where,
	)


def main() -> None:
	arg_parser = argparse.ArgumentParser(description="Converts JSON to MySQL.")
	arg_parser.add_argument(
		"-i",
		"--input",
		nargs="+",
		default=None,
		help="Path(s) to the input `.json` file(s). Default: `parcoursup.json`.",
		metavar="<path>",
	)
	arg_parser.add_argument(
		"-o",
		"--output",
		default="parcoursup.sql",
		help="Path to the output `.sql` file. Default: `parcoursup.sql`.",
		metavar="<path>",
	)
	arg_parser.add_argument(
		"-d",
		"--database",
		default="parcoursup",
		help="Name of the MySQL database. Default: `parcoursup`.",
		metavar="<name>",
	)
	arg_parser.add_argument(
		"-t",
		"--table",
		default="parcoursup",
		help="Name of the MySQL table. Default: `parcoursup`.",
		metavar="<name>",
	)
	arg_parser.add_argument(
		"-r",
		"--rename",
		nargs="+",
		help="Rename keys. Use key:new_key.",
		metavar="<key:new_key>",
	)
	arg_parser.add_argument(
		"-p",
		"--primary",
		nargs="+",
		help="Primary key(s).",
		metavar="<key>",
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
		help="Check for percentages (0 to 100).",
	)
	arg_parser.add_argument(
		"-C",
		"--counts",
		action="store_true",
		help="Check for counts (>= 0).",
	)
	arg_parser.add_argument(
		"-s",
		"--split",
		type=int,
		default=15000,
		help="Split insert requests into multiple `.sql` files. Default: `15000`.",
	)
	arg_parser.add_argument(
		"--print",
		action="store_true",
		help="Print non-null percentages or counts instead of producing a `.sql` file.",
	)
	arg_parser.add_argument(
		"--range",
		help="Process entries within the specified range (zero-indexed)",
		metavar="<start,end>",
	)
	arg_parser.add_argument(
		"--range-start",
		type=int,
		help="Set the starting entry index for the processing range",
		metavar="<n>",
	)
	arg_parser.add_argument(
		"--range-end",
		type=int,
		help="Set the ending entry index for the processing range",
		metavar="<n>",
	)
	arg_parser.add_argument(
		"--first",
		type=int,
		help="Process only the first N entries",
		metavar="<n>",
	)
	arg_parser.add_argument(
		"--last",
		type=int,
		help="Process only the last N entries",
		metavar="<n>",
	)
	arg_parser.add_argument(
		"-f",
		"--fds",
		help="Path to the file containing functional dependencies to check.",
		metavar="<path>",
	)
	arg_parser.add_argument(
		"-w",
		"--where",
		help="Append a custom WHERE clause for functional dependency checks.",
		metavar="<clause>",
	)
	args = arg_parser.parse_args()
	config = Config(args)
	run(config)


if __name__ == "__main__":
	main()
