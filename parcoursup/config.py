from __future__ import annotations
import argparse


class Config:
	def __init__(self, args: argparse.Namespace):
		if args.input is not None:
			self.json_file_paths: list[str] = args.input
		elif args.fds:
			self.json_file_paths: list[str] = []
		else:
			self.json_file_paths: list[str] = ["parcoursup.json"]
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
		self.split: int = args.split
		self.print_mode: bool = args.print
		self.range_start: int | None = args.range_start
		self.range_end: int | None = args.range_end
		if args.range:
			start, end = args.range.split(",", 1)
			self.range_start = int(start)
			self.range_end = int(end)
		self.first: int | None = args.first
		self.last: int | None = args.last
		self.fds: str | None = args.fds
		self.where: str | None = args.where
