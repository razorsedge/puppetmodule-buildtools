#!/bin/bash
MODULE=$1
if [ -z $MODULE ]; then
  echo "ERROR: Must supply target directory name."
  exit 1
fi

rsync -a TEMPLATE/ ${MODULE}/
for FILE in metadata.json README.md DEVELOP.md .fixtures.yml tests/*.pp manifests/*.pp .project; do
  sed -i -e "s|TEMPLATE|${MODULE}|g" ${MODULE}/${FILE}
done

cd ${MODULE}
git init
#mv pre-commit .git/hooks/
rm pre-commit
ln -s ~/git/drwahl/puppet-git-hooks/pre-commit .git/hooks/pre-commit
git add * .gitignore .fixtures.yml .travis.yml .project
git commit -m 'first commit'
git tag 0.0.0
git remote add origin git@github.com:razorsedge/puppet-${MODULE}.git
git flow init -d
#git push -u origin master
#git push -u origin develop
