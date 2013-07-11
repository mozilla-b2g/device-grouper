#!/bin/bash

# Copyright (C) 2012 Mozilla Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

EXTRACT_RC="$PWD/extract.rc"

install_blobs() {
    mkdir -p download-$1 &&
    (cd download-$1 && shasum -p -c $3) ||
    for BLOB in $2 ; do
        rm -f download-$1/$BLOB &&
        curl https://dl.google.com/dl/android/aosp/$BLOB -o download-$1/$BLOB ||
        exit -1
    done &&
    (cd download-$1 && shasum -p -c $3) &&
    for BLOB in $2 ; do
        tar xvfz download-$1/$BLOB -C download-$1 ||
        exit -1
    done &&
    for BLOB_SH in download-$1/extract-*.sh ; do
        BASH_ENV="$EXTRACT_RC" bash $BLOB_SH
    done
}

GROUPER_BLOBS="
    asus-grouper-jdq39-b6907aa5.tgz
    broadcom-grouper-jdq39-4a9b93a2.tgz
    elan-grouper-jdq39-82c8d127.tgz
    invensense-grouper-jdq39-28df082f.tgz
    nvidia-grouper-jdq39-738059f9.tgz
    nxp-grouper-jdq39-28a5fe9a.tgz
    widevine-grouper-jdq39-73fc49a2.tgz
    "

CSUM_LIST="$PWD/blob-shasums"

cd ../../.. &&
install_blobs nexus-7 "$GROUPER_BLOBS" "$CSUM_LIST"
