#!/bin/bash
if ! ruby --version | grep -q "ruby 1.9"; then
  echo "ERROR: You must use a Ruby version >1.9."
  exit 1
fi
PATH=/opt/puppet/bin:$PATH
TAG=$1
if [ -z $TAG ]; then
  echo "ERROR: Must supply tag."
  exit 1
fi
if [ ! -x ~/bin/git-log-to-changelog ]; then
  echo "ERROR: Require ~/bin/git-log-to-changelog."
  exit 4
fi
if [ -f Modulefile ]; then
  echo "ERROR: Remove the Modulefile and convert to metadata.json."
  exit 3
fi
rake spec_clean 2>/dev/null
bundle exec rake spec_clean 2>/dev/null
mv Gemfile.lock .Gemfile.lock
git flow release start $TAG || exit 2
sed -i "/\"version\":/s|: \".*|: \"${TAG}\",|" metadata.json
git add metadata.json
git commit -m "Update versions for $TAG release."
git flow release finish -m "Puppet Forge $TAG release." $TAG && \
git checkout master && \
git-log-to-changelog | tail -n+5 >CHANGELOG &&
puppet module build . && \
rm -f CHANGELOG
git checkout develop
mv .Gemfile.lock Gemfile.lock

echo "** Upload via browser to the Forge"
echo git push origin develop
echo git push origin master
echo git push origin $TAG
echo "** Post to blog"
