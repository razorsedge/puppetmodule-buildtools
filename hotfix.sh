#!/bin/bash
exit 999
TAG=$1
if [ -z $TAG ]; then
  echo "ERROR: Must supply tag."
  exit 1
fi

#git flow hotfix start $TAG || exit 2
git checkout hotfix/$TAG || exit 2
sed -i "s|^version .*|version '${TAG}'|" Modulefile
git add Modulefile
git commit -m "Update versions for $TAG hotfix."
git flow hotfix finish -m "Puppet Forge $TAG release." $TAG && \
puppet module build $(basename `pwd`)

echo "** Upload via browser to the Forge"
echo git push origin develop
echo git push origin master
echo git push origin $TAG
