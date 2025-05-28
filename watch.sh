#!/bin/sh

watchexec -r -w src -e cr "LOG_LEVEL=trace crystal run --error-trace src/splitters.cr -- -p 3007"
