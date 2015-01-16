#!/bin/bash

show_usage() {
  echo "Usage:  $0 PREVIOUS_VERSION NEW_VERSION" >&2
}

if [ $# -ne 2 ] ; then
  show_usage
  exit 1
fi

previous_version=$1
new_version=$2


DIRS="
content/documentation
"

parent_dir=$(pwd)

for dir in $DIRS ; do
  set -e

  cd $parent_dir
  cd $dir

  # Generate new X.Y.X.html file.
  cp ${previous_version}.html ${new_version}.html
  gsed -i "s/^title:.*/title: \"${new_version}\"/" ${new_version}.html
  gsed -i "s/^link_text:.*/link_text: \"Version ${new_version}\"/" ${new_version}.html
  gsed -i "s/^version:.*/version: \"${new_version}\"/" ${new_version}.html

  # Generate new X.Y.Z/ directory.
  svn export ${previous_version} ${new_version} >/dev/null

  # Replace "version" field in all the new files within the new directory.
  cd ${new_version}/
  set +e
  gsed -i "s/^version:.*/version: \"${new_version}\"/" *.html 2>/dev/null
  gsed -i "s/^version:.*/version: \"${new_version}\"/" */*.html 2>/dev/null
  gsed -i "s/^version:.*/version: \"${new_version}\"/" */*/*.html 2>/dev/null
  gsed -i "s/^version:.*/version: \"${new_version}\"/" */*/*/*.html 2>/dev/null
  gsed -i "s/^version:.*/version: \"${new_version}\"/" */*/*/*/*.html 2>/dev/null
  cd ..
  set -e
done


echo "DONE"
