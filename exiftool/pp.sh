#!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
library_path=${parent_path}/exiftoolSource/lib/

cd "${library_path}"
echo "executing at" $(pwd)

input=${parent_path}/exiftoolSource/exiftool
echo "input from" ${input}

output=${1:-${parent_path}/exiftoolbin}
echo "output to" ${output}

pp -o "${output}" -M Image::ExifTool -M File::RandomAccess "${input}"