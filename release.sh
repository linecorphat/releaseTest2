#!/bin/sh
VERSION=$1
if [ $# -ne 1 ]; then
  echo "Usage) ./release.sh [VERSION]"
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

if [ "`echo $(git diff --name-status remotes/origin/$TARGET_BRANCH) | sed -E 's/(M|A) CHANGELOG\.md//'`" ]; then
  echo "There is a difference between remote and local."
  exit 1
fi
echo "================================================"
echo "BEGIN RELEASE FLOW. VERSION = ${VERSION}"
echo "================================================"
PARENT_DIR=$(dirname $(cd $(dirname $0); pwd))
echo "sed -i \"\" \"s/version = '\(.*\)/version = '${VERSION}'/\" ${PARENT_DIR}/build.gradle"
sed -i "" "s/version = '\(.*\)/version = '${VERSION}'/" ${PARENT_DIR}/build.gradle
echo "git checkout -b release-${VERSION}"
git checkout -b release-${VERSION}
echo "git add ${PARENT_DIR}/build.gradle"
git add ${PARENT_DIR}/build.gradle
echo "git commit -m "Bump version to ${VERSION}""
git commit -m "Bump version to ${VERSION}"
echo "git push origin release-${VERSION}"