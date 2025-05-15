#!/bin/bash

# exit when any command fails
set -e

new_ver=$1

echo "new version: $new_ver"

# Simulate release of the new docker images
docker tag nginx:latest francesc2509/nginx:$new_ver

# Push new version to dockerhub
docker push francesc2509/nginx:$new_ver

# Create temporary folder
tmp_dir=$(mktemp -d)
echo $tmp_dir

# Clone GitHub repo
git clone git@github.com:francesc2509/argocd-test.git $tmp_dir

# Update image tag
sed -i '' -e "s/francesc2509\/nginx:.*/francesc2509\/nginx:$new_ver/g" $tmp_dir/lesson-158/my-app/1-deployment.yaml

# Commit and push
cd $tmp_dir
git add .
git commit -m "Update image to $new_ver"
git push

# Optionally on build agents - remove folder
rm -rf $tmp_dir