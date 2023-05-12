#!/bin/bash

DIR_TO_FILL="./mnt/disk0"

mkdir -p "${DIR_TO_FILL}"
pushd "${DIR_TO_FILL}" || exit 1

DATA_SOURCE="/dev/zero"
BLOCK_SIZE=512
BIG_FILE_FACTOR=500

FILE_EXTENSIONS=(
    ".mp4"
    ".mp3"
    ".jpg"
    ".png"
    ".txt"
    ".bin"
    ".docx"
)

# Generate layers of folders, covering the alphabet inside each one
for x in {a..l}/{m..t}/{w..z}
do
    mkdir -p "${x}"

    for n in {1..10}; do
        # pick a random extension
        extension=${FILE_EXTENSIONS[ $RANDOM % ${#FILE_EXTENSIONS[@]} ]}
        filename="${x}/file$( printf %03d "$n" )${extension}"

        if [[ $(( RANDOM % 5 )) -eq 4 ]]; then
            # Make a big file ~10% of the time
            size=$(( RANDOM*BIG_FILE_FACTOR + 1024 ))
        else
            # Make a small file normally
            size=$(( RANDOM + 1024 ))
        fi
        # Dividing by BLOCK_SIZE because it speeds up `dd`, but gives approx the same size
        size=$(( size / BLOCK_SIZE ))

        # make file full of zeroes
        dd if="${DATA_SOURCE}" of="${filename}" bs="${BLOCK_SIZE}" count="${size}" &> /dev/null

        if [[ $(( RANDOM % 10 )) -ge 8 ]]; then
            # Make an old file ~20% of the time
            touch -d "-$(( RANDOM % 3 )) year -$(( RANDOM % 13 )) month -$(( RANDOM % 30 )) day $(( RANDOM % 25 )) hours" "${filename}"
        fi
    done
done

# sparse files
