#!/bin/bash

# The tag for the Docker image.
# Source: https://hub.docker.com/_/swift/
tag='5.6-focal'

docker run -it --rm -v "$PWD:$PWD" -w "$PWD" swift:$tag swift test
