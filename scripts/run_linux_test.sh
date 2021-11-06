#!/bin/bash

docker run -it --rm -v "$PWD:$PWD" -w "$PWD" swift:<tag> swift test
