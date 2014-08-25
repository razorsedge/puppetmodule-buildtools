#!/bin/bash
TAG=$1
if [ -z $TAG ]; then
  echo "ERROR: Must supply tag."
  exit 1
fi

rake spec_clean 2>/dev/null
git flow release start $TAG || exit 2
sed -i "s|^version .*|version '${TAG}'|" Modulefile
git add Modulefile
if [ -f .metadata.json ]; then
  cp -p .metadata.json metadata.json
fi
#if [ -f metadata.json ]; then
#  sed -i "/\"version\":/s|: \".*|: \"${TAG}\",|" metadata.json
#  git add metadata.json
#fi
git commit -m "Update versions for $TAG release."
git flow release finish -m "Puppet Forge $TAG release." $TAG && \
git checkout master && \
git-log-to-changelog | tail -n+5 >CHANGELOG &&
puppet module build && \
rm -f CHANGELOG metadata.json
git checkout develop

echo "** Upload via browser to the Forge"
echo git push origin develop
echo git push origin master
echo git push origin $TAG
echo "** Post to blog"
