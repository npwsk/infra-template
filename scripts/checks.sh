#!/bin/bash

# install depenedencies

echo 'Run npm ci'
npm ci

# compile typescript

echo 'Run npm run ts'
npm run ts
if [ "$?" != "0" ]; then
  echo 'Error running npm run ts'
  exit 1
fi

# run linter

echo 'Run npm run lint'
npm run lint
if [ "$?" != "0" ]; then
  echo 'Error running npm run lint'
  exit 1
fi

echo 'Checks finished'
