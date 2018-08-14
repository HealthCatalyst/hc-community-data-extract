#!/bin/sh

# Add filters like sort order
./bulk 'sort=latestActivityDesc' > data_pre.csv

# Shorten troublesome ID number
sed data_pre.csv -e 's/-9223372036854775808/9999/g' > data.csv