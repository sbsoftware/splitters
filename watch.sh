#!/bin/sh

export DATABASE_URL=sqlite3://./data.db
export LOG_LEVEL=trace

lib/crumble/src/watch.sh splitters 3007
