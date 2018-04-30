#!/bin/bash
base_folder=$(pwd)

cd ../dohko
mvn clean install -DskipTests
projects=("pom.xml")

for pom in $projects; do 
  echo $pom
  cd $base_folder/../dohko/
  version=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -v '\[')
  artifactId=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.artifactId | grep -v '\[')
  groupId=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.groupId | grep -v '\[')
  echo "Version: "$version
  echo "artifactId: "$artifactId
  echo "groupId: "$groupId

  cd $base_folder/snapshots
  mvn install:install-file -DgroupId=$groupId -DartifactId=$artifactId -Dversion=$version -Dfile=$base_folder/../dohko/target/$artifactId-$version.jar -Dpackaging=jar  -DpomFile=$base_folder/../dohko/$pom -DlocalRepositoryPath=.  -DcreateChecksum=true

  
done

