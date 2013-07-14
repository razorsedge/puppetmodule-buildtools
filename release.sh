#!/bin/bash
TAG=$1
if [ -z $TAG ]; then
  echo "ERROR: Must supply tag."
  exit 1
fi

git flow release start $TAG || exit 2
sed -i "s|^version .*|version '${TAG}'|" Modulefile
git add Modulefile
git commit -m "Update versions for $TAG release."
git flow release finish -m "Puppet Forge $TAG release." $TAG && \
puppet module build $(basename `pwd`)
rm -f CHANGELOG

echo "** Upload via browser to the Forge"
echo git push origin develop
echo git push origin master
echo git push origin $TAG
