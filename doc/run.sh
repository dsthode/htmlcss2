#!/bin/bash

docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex:2.11.4 $*