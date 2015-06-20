#!/bin/sh
# Fri Sep 19 12:25:59 EEST 2014, nickkouk

echo 'Give the commit message'
read commit_log

git add -A
git commit -m "$commit_log"

echo 'Pushing to master'
git push origin master

echo '*** Push Successfully completed ***'
exit 0
