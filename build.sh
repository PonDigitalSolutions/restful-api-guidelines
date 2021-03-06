#!/usr/bin/env bash
# Script to build Pon Guidelines (static HTML, PDF)

set -ex

pushd $(dirname "$0") > /dev/null
SCRIPT_DIR=`pwd -P`
popd > /dev/null
BUILD_DIR=${SCRIPT_DIR}/output

rm -rf ${BUILD_DIR}
mkdir "${BUILD_DIR}"
docker pull asciidoctor/docker-asciidoctor

./check_rule_ids.sh

docker run -v "${SCRIPT_DIR}:/documents/" asciidoctor/docker-asciidoctor asciidoctor --verbose --trace -D /documents/output index.adoc
docker run -v "${SCRIPT_DIR}:/documents/" asciidoctor/docker-asciidoctor asciidoctor-pdf --verbose --trace -D /documents/output index.adoc
# docker run -v ${SCRIPT_DIR}:/documents/ asciidoctor/docker-asciidoctor asciidoctor-epub3 --verbose --trace -D /documents/output index.adoc

cp models/money-1.0.0.yaml "${BUILD_DIR}/"
cp -r assets "${BUILD_DIR}/"
# cp -r -n legacy/* ${BUILD_DIR}/

./generate_rules_json.sh

mv "${BUILD_DIR}/index.pdf" "${BUILD_DIR}/pon-guidelines.pdf"   
# mv ${BUILD_DIR}/index.epub ${BUILD_DIR}/pon-guidelines.epub
