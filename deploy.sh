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


if [ "$KEEP_OLD_VERSION" == "true" ]
then 
    if [ ! -z "$MAVEN_VERSION" ]
    then
        echo "Get old version ..."
        OLD_VERSION=`mvn --settings /settings.xml org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=project.version -q -DforceStdout`
        echo "Update project maven version..."
        mvn --settings /settings.xml versions:set -DnewVersion=$OLD_VERSION.$MAVEN_VERSION
    fi
else
    if [ ! -z "$MAVEN_VERSION" ]
    then
        echo "Update project maven version..."
        mvn --settings /settings.xml versions:set -DnewVersion=$MAVEN_VERSION
    fi
fi


echo "Deploy maven project with customize config ..."
mvn deploy --settings /settings.xml -Dmaven.test.skip=true

echo "Deploy success!"