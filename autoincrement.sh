#!/bin/sh

echo 'Auto Increment version'

#"./version.properties"
#MINOR=1
#MAJOR=1
#PATCH=1
#VERSION_CODE=1
#VERSION_NAME=1.1.1

file=$1
BUMP_MAJOR=$2
BUMP_MINOR=$3
BUMP_PATCH=$4
NEW_VERSION_CODE=$5

echo "File: $file"
echo "Major: $BUMP_MAJOR"
echo "Minor: $BUMP_MINOR"
echo "Patch: $BUMP_PATCH"
echo "Version Code: $NEW_VERSION_CODE"

MAJOR_VERSION="1"
MINOR_VERSION="1"
PATCH_VERSION="1"
VERSION_CODE="1"

while IFS='=' read -r key value;
do
  if [ "$key" = 'MAJOR' ]; then
    MAJOR_VERSION=$value
  elif [ "$key" = 'MINOR' ]; then
    MINOR_VERSION=$value
  elif [ "$key" = 'PATCH' ]; then
    PATCH_VERSION=$value
  elif [ "$key" = 'VERSION_CODE' ]; then
    VERSION_CODE=$value
  fi
done <"$file"

if $BUMP_MAJOR; then NEW_MAJOR_VERSION=$((MAJOR_VERSION+1))
else NEW_MAJOR_VERSION=$MAJOR_VERSION
fi

if $BUMP_MINOR; then NEW_MINOR_VERSION=$((MINOR_VERSION+1))
else NEW_MINOR_VERSION=$MINOR_VERSION
fi

if $BUMP_PATCH; then NEW_PATCH_VERSION=$((PATCH_VERSION+1))
else NEW_PATCH_VERSION=$PATCH_VERSION
fi

SEARCH_VERSION_NAME="VERSION_NAME=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}"
REPLACE_VERSION_NAME="VERSION_NAME=${NEW_MAJOR_VERSION}.${NEW_MINOR_VERSION}.${NEW_PATCH_VERSION}"
echo "$REPLACE_VERSION_NAME"

SEARCH_VERSION_CODE="VERSION_CODE=${VERSION_CODE}"
REPLACE_VERSION_CODE="VERSION_CODE=${NEW_VERSION_CODE}"
echo "$REPLACE_VERSION_CODE"

chmod +x $file
#Replace major
sed -i -e "s/MAJOR=$MAJOR_VERSION/MAJOR=$NEW_MAJOR_VERSION/gi" $file
#Replace minor
sed -i -e "s/MINOR=$MINOR_VERSION/MINOR=$NEW_MINOR_VERSION/gi" $file
#Replace patch
sed -i -e "s/PATCH=$PATCH_VERSION/PATCH=$NEW_PATCH_VERSION/gi" $file
#Replace version name
sed -i -e "s/$SEARCH_VERSION_NAME/$REPLACE_VERSION_NAME/gi" $file
#Replace version code
sed -i -e "s/$SEARCH_VERSION_CODE/$REPLACE_VERSION_CODE/gi" $file

# Commit changed file to git
if [ -n "$(git status --porcelain)" ]; then
    echo "Uncommitted changes found in your working copy."
    git add $file
    git commit -m "Updating version to ${NEW_MAJOR_VERSION}.${NEW_MINOR_VERSION}.${NEW_PATCH_VERSION}"
    git push --force
    exit 0
fi