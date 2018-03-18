#!/bin/bash
set -ev
git clone https://${GH_REF} .deploy_git
cd .deploy_git
git checkout master
cd ../
mv .deploy_git/.git/ ./public/
cd ./public
git config user.name "msChen92"
git config user.email "18936201961@139.com"
##add commit timestamp
git add .
git commit -m "Travis CI Auto Builder at `date + "%Y-%m-%d %H:%M"`"
git push --force --quiet "https://${trivas_token}@${GH_REF}" master:master