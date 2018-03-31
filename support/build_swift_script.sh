#!/bin/bash

mkdir swift-build
cd swift-build
git clone git://github.com/haritowa-university/latex-project-builder.git
cd latex-project-builder
swift build -c release
cp .build/release/latex-project-builder /container/latex-project-builder
cd ../..
rm -rf swift-build
