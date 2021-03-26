#!/bin/bash

docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` dsthode_pandoc pandoc \
    pec1.md \
    -f markdown \
    -t html \
    -o pec1.html
