require "spec"
require "hot-crumble"
require "sqlite3"

ENV["ORMA_CONTINUOUS_MIGRATION"] ||= "true"

TEST_DB_CONNECTION_STRING = "sqlite3:%3Amemory%3A?max_pool_size=1&prepared_statements_cache=false"

Orma.db_connection_string = TEST_DB_CONNECTION_STRING

require "../src/environment"
