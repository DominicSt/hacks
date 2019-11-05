#!/bin/bash
####################
# Increment SemVerTag
# https://semver.org/
####################
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

GIT_DIR=$1
MAJOR_INCREMENT=$2
MINOR_INCREMENT=$3
PATCH_INCREMENT=$4


pushd $GIT_DIR >/dev/null

read OLDMAJOR OLDMINOR OLDPATCH <<<$(git tag | awk -F "[_.]" '{print $3, $4, $5}' -| sort -k 1 -k 2 -k 3 -n|tail -1)

if [ "$MAJOR_INCREMENT" == "true" ]
then
  echo "TAG_"$(($OLDMAJOR+1))"."1"."1
else
  if [ "$MINOR_INCREMENT" == "true" ]
  then
    echo "TAG_"$OLDMAJOR"."$(($OLDMINOR+1))"."1
  else
     if [ "$PATCH_INCREMENT" == "true" ]
     then
       echo "TAG_"$OLDMAJOR"."$OLDMINOR"."$(($OLDPATCH+1))
    fi
  fi
fi
