#!/bin/bash

cd "$(dirname "$0")"

# TODO: what about import.sql?  It gets formatted too ugly
pg_format -L -s 2 -w 100 tables.sql >tables.fmt.sql
mv tables.fmt.sql tables.sql
