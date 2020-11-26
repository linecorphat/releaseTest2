#!/bin/sh

VERSION=$1

if [ $# -ne 1 ]; then
  echo "Usage) ./changelog.sh [VERSION]"
  exit 1
fi

TARGET_BRANCH="master"
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
if [ "$CURRENT_BRANCH" != "$TARGET_BRANCH" ]; then
  echo "Please change branch to $TARGET_BRANCH."
  exit 1
fi

if ! git fetch; then
  echo "git fetch error."
  exit 1
fi

echo "================================================"
echo "BEGIN CREATE CHANGELOG. VERSION = ${VERSION}"
echo "================================================"

echo "git output CHANGELOG.md for ${VERSION}"
docker run -it --rm -v $PWD:/workdir suncheez/git-chglog --next-tag ${VERSION} -o CHANGELOG.md
git add CHANGELOG.md

echo "================================================"
echo "END   CREATE CHANGELOG. VERSION = ${VERSION}"
echo "================================================"


