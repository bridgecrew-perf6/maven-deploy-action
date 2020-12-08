#!/bin/bash

set -e

echo $SETTINGS_VALUE >> /settings.xml

if [ -z "$REPOSITORY" ]
then
    echo "You must provide the $REPOSITORY parameter with url of git repository"
    exit 1
fi


echo "Clone from git repository ..."
git clone $REPOSITORY /project

cd /project 

echo "Deploy maven project with customize config ..."
mvn deploy --settings /settings.xml -Dmaven.test.skip=true

echo "Deploy success!"