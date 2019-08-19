#!/bin/bash
# The Travis CI build work flow.
# © 2018-2019 Cotes Chung
# MIT License

USERNAME=cotes2020
PROJECT=chirpy

POSTS_REPO=https://${GH_TOKEN}@github.com/${USERNAME}/blog-posts.git
META_REPO=https://${GH_TOKEN}@github.com/${USERNAME}/blog-meta.git

BLOG_REPO=https://${GH_TOKEN}@github.com/${USERNAME}/$USERNAME.github.io.git
DEMO_REPO=https://${GH_TOKEN}@github.com/${USERNAME}/$PROJECT-demo.git

PROJ_LOCAL=$(pwd)   # equls to $TRAVIS_BUILD_DIR/$USERNAME/$PROJECT
POSTS_LOCAL=../blog-posts
META_LOCAL=../blog-meta
DEPLOY_CACHE=../deploy

declare -A TASKS

clear() {
  if [[ -d $1 ]]; then
    rm -rf $1
  fi
}


init() {
  # skip if build is triggered by pull request
  if [[ $TRAVIS_PULL_REQUEST == "true" ]]; then
    echo "this is PR, exiting"
    exit 0
  fi

  # enable error reporting to the console
  set -e

  clear "_site"

  rm -f ./README.md   # $PROJ_LOCAL/README.md

  # Git settings
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis-CI"

  git clone ${POSTS_REPO} ${POSTS_LOCAL}
  git clone ${META_REPO} ${META_LOCAL} --depth=1
}


combine() {
  cd $PROJ_LOCAL

  TEMPLATE=(
    "tabs/about.md"
    "LICENSE"
    "_posts"
    "categories"
    "tags"
    "assets/data"
    "assets/img")

  for i in "${!TEMPLATE[@]}"
  do
    rm -rf ${TEMPLATE[${i}]}
  done

  cp -a ./* ${POSTS_LOCAL}
  echo "[INFO] $(date) - Combined posts."

  cp -a ${META_LOCAL}/* ${POSTS_LOCAL}
  echo "[INFO] $(date) - Combined meta-data."
}


build() {

  build_cmd="bundle exec jekyll build"

  if [[ $1 == $POSTS_LOCAL ]]; then
    combine
    build_cmd="JEKYLL_ENV=production $build_cmd"
  fi

  cd $1
  echo "\$ cd $(pwd)"

  python _scripts/tools/init_all.py

  echo "\$ $build_cmd"
  eval $build_cmd

  echo "[INFO] $(date) - Build a site in $(pwd)"
}


deploy() {
  # $1=build_proj, $2=deploy_repo

  build $1

  clear $DEPLOY_CACHE

  msg="Travis-CI automated deployment #${TRAVIS_BUILD_NUMBER}"

  git clone $2 $DEPLOY_CACHE --depth=1

  if [[ $2 == $DEMO_REPO ]]; then
    cp $DEPLOY_CACHE/CNAME _site
    msg+="."
  else # deploy the Blog
    msg+=" from the Framework."
  fi

  rm -rf $DEPLOY_CACHE/*
  cp -r _site/* $DEPLOY_CACHE

  cd $DEPLOY_CACHE

  opt=""
  count=`git log --pretty=oneline |wc -l`

  if [[ $count > 0 ]]; then
    git update-ref -d HEAD # Overried the last commit message.
    opt="-f"
  fi

  git add -A
  git commit -m "$msg" -q
  git push $2 master:master $opt

  repo=$(basename $2)
  latest_commit=`git log -1 --pretty=oneline |awk '{print $1}'`

  TASKS+=( [${repo%.*}]=$latest_commit )
}


# Keep watching to the builds of GitHub Pages
oversee_gh_pages() {
  REPO_NAME=$1
  LATEST_COMMIT=$2

  CACHE=$REPO_NAME-status.json

  curl -H "Authorization: token $GH_TOKEN" \
    https://api.github.com/repos/${USERNAME}/${REPO_NAME}/pages/builds/latest \
    -o $CACHE -s

  pages_commit=`jq -r '.commit' $CACHE`
  status=`jq -r '.status' $CACHE`

  echo "{ repo: $REPO_NAME, status: $status, pages_commit: $pages_commit }"
  echo "$REPO_NAME lates commit: $LATEST_COMMIT"

  if [[ $status == 'built' && $LATEST_COMMIT != $pages_commit ]]; then
    echo "Trigger a fucking GitHub Pages build for $REPO_NAME !"
    curl -H "Authorization: token $GH_TOKEN" \
        -H "Accept: application/vnd.github.mister-fantastic-preview+json" \
        -X POST https://api.github.com/repos/${USERNAME}/${REPO_NAME}/pages/builds \
        -s > /dev/null
  fi
}


main() {
  init
  deploy $PROJ_LOCAL $DEMO_REPO
  # deploy $POSTS_LOCAL $BLOG_REPO

  wait=10
  sleep $wait # wait 10 seconds for the GitHub Pages to build.

  echo "Waitting"

  while [[ $wait -gt 0 ]]; do
    sleep 1
    echo -ne '.'
    ((wait--))
  done
  echo "" # new line

  cd $TRAVIS_BUILD_DIR
  for repo in "${!TASKS[@]}"; do
    oversee_gh_pages $repo ${TASKS[$repo]}
  done
}


main
