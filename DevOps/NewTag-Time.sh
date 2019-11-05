#!/bin/sh
###########
# Create tag based on current datetime.
# Format: TAG_2019.11.05.1538
###########

tag_prefix="TAG"
current_time=$(date "+%Y.%m.%d.%H%M")

echo "$tag_prefix.$current_time"
