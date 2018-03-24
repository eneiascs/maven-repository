#!/bin/bash
base_folder=$(pwd)
project_folder=$base_folder/../command
cd $project_folder
mvn clean install -DskipTests

version=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -v '\[')
artifact_id=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.artifactId | grep -v '\[')
group_id=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.groupId | grep -v '\[')
echo "Version: "$version
echo "artifactId: "$artifact_id
echo "groupId: "$group_id


cd $base_folder/snapshots
mvn install:install-file -DgroupId=$group_id -DartifactId=command -Dversion=$version -Dfile=$project_folder/target/$artifact_id-$version.jar -Dpackaging=jar  -DpomFile=$project_folder/pom.xml -DlocalRepositoryPath=.  -DcreateChecksum=true
  


