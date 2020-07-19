#!/bin/sh

# if [ "`git status -s`" ]
# then
#     echo "The working directory is dirty. Please commit any pending changes."
#     exit 1;
# fi

git config --global push.default matching
git config --global user.email "${GitHubEMail}"
git config --global user.name "${GitHubUser}"

git checkout --orphan master
git reset --hard
git commit --allow-empty -m "Initializing master branch"
git push origin master
git checkout src

echo "Deleting old publication"
rm -rf public
mkdir public

echo "Checking out master branch into public"
git worktree add -f -B master public origin/master

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating master branch"
cd public
git add --all
git commit -m "Publishing to master (deploy.sh)"

echo "Pushing to github"
git push --quiet --force https://${GitHubKEY}@github.com/${GitHubUser}/${GitHubRepo}.git master