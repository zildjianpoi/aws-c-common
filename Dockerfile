# Build Stage
FROM ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang

## Add source code to the build stage.
ADD . /aws-c-common
WORKDIR /aws-c-common

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
WORKDIR aws-c-common-build
RUN CC=clang CXX=clang++ cmake .. -DENABLE_FUZZ_TESTS=ON -DENABLE_SANITIZERS=ON
RUN make

# Package Stage
FROM ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /aws-c-common/aws-c-common-build/tests/aws-c-common-fuzz-base64_encoding_transitive /

