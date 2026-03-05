from __future__ import annotations
import argparse


class Config:
	def __init__(self, args: argparse.Namespace):
		self.json_file_paths: list[str] = args.input
		self.mysql_file_path: str = args.output
		self.database_name: str = args.database
		self.table_name: str = args.table
		self.renames: dict[str, str] = {}
		if args.rename:
			for rename in args.rename:
				key, new_key = rename.split(":", 1)
				self.renames[key] = new_key
		self.primary_keys: list[str] = args.primary or []
		self.not_null: bool = args.not_null
		self.percentages: bool = args.percentages
		self.counts: bool = args.counts
