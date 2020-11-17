#!/bin/bash

rm -rf ./dist/

mkdir ./dist/

sass ./src/css/:./dist/css/ --no-source-map

mkdir ./dist/public/

cp -r ./src/public/ ./dist/public/

mkdir ./dist/js

cp -r ./src/js/ ./dist/js/