#!/bin/bash
base_folder=$(pwd)
git clone https://github.com/alessandroleite/dohko.git ../dohko
cd ../dohko
projects=$(ls -d */pom.xml)
mvn clean install
cd client
mvn clean install 
cd ../fm-gui
mvn clean install

cd ../metrics
mvn clean install
for pom in $projects; do 
  echo $pom
  folder=$(echo $pom | awk -F '/' '{print $1}')
  echo $folder 
  cd $base_folder/../dohko/$folder
  version=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -v '\[')
  artifactId=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.artifactId | grep -v '\[')
  groupId=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.groupId | grep -v '\[')
  echo "Version: "$version
  echo "artifactId: "$artifactId
  echo "groupId: "$groupId

  cd $base_folder/snapshots
  mvn install:install-file -DgroupId=$groupId -DartifactId=$artifactId -Dversion=$version -Dfile=$base_folder/../dohko/$folder/target/$artifactId-$version.jar -Dpackaging=jar  -DpomFile=$base_folder/../dohko/$pom -DlocalRepositoryPath=.  -DcreateChecksum=true

  
done

