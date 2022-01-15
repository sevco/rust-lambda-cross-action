#!/bin/bash
# build and pack a rust lambda library
# https://aws.amazon.com/blogs/opensource/rust-runtime-for-aws-lambda/

set -e

if [ "$RELEASE" == "true" ]; then
    PROFILE="release"
else
    PROFILE="debug"
fi

function package() {
    file="$1"
    OUTPUT_FOLDER="$TARGET_DIRECTORY/lambda/${file}"
    if [[ "${PROFILE}" == "release" ]] && [[ -z "${DEBUGINFO}" ]]; then
        objcopy --only-keep-debug "$file" "$file.debug"
        objcopy --strip-debug --strip-unneeded "$file"
        objcopy --add-gnu-debuglink="$file.debug" "$file"
    fi
    rm "$file.zip" > 2&>/dev/null || true
    rm -r "${OUTPUT_FOLDER}" > 2&>/dev/null || true
    mkdir -p "${OUTPUT_FOLDER}"
    cp "${file}" "${OUTPUT_FOLDER}/bootstrap"
    cp "${file}.debug" "${OUTPUT_FOLDER}/bootstrap.debug" > 2&>/dev/null || true

    if [[ "$PACKAGE" != "false" ]]; then
        zip -j "$TARGET_DIRECTORY/lambda/${file}.zip" "${OUTPUT_FOLDER}/bootstrap"
    fi
}


TARGET_DIRECTORY="$PWD/target"
cd $TARGET_DIRECTORY/x86_64-unknown-linux-musl/$PROFILE
(
    EXECUTABLES=$(cargo metadata --no-deps --format-version=1 | jq -r '.packages[] | .targets[] | select(.kind[] | contains("bin")) | .name')
    IFS=$'\n'
    for executable in $EXECUTABLES; do
        echo "Packaging $executable"
        package "$executable"
    done
) 
