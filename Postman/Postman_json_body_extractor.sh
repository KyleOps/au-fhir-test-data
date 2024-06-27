#!/bin/bash

# Check if an argument was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input-json-file>"
    exit 1
fi

input_file="$1"
# Extract the base name of the file without extension for folder naming
output_dir=$(basename "$input_file" .json)

# Create the output directory if it does not exist
mkdir -p "$output_dir"

# Counter for file naming
counter=1

# Preprocess the JSON to remove \r\n and surrounding double quotes from raw JSON fields
sed -e 's/\\r\\n//g' -e 's/\\"raw\\": \\"\({.*}\)\\"/\\"raw\\": \1/g' "$input_file" > temp.json

# Extract each raw JSON, decode, and output to a separate file
jq -r '.item[] | select(.name == "Validate") | .item[] | .item[] | .request.body.raw' temp.json | while IFS= read -r raw_json; do
    echo "${raw_json}" | jq '.' > "${output_dir}/extracted_${counter}.json"
    ((counter++))
done

# Clean up temporary file
rm temp.json
