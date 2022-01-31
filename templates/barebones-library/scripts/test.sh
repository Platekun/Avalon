#!/bin/bash

GREEN="\e[32m"
ENDCOLOR="\e[0m"

echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}🔎 Running tests...${ENDCOLOR}")

# ███████╗███████╗████████╗██╗   ██╗██████╗ 
# ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
# ███████╗█████╗     ██║   ██║   ██║██████╔╝
# ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
# ███████║███████╗   ██║   ╚██████╔╝██║     
# ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

projectName="{{projectName}}"
imageName="$projectName-test-image"
dockerFilePath="./docker/test.Dockerfile"
containerName="$projectName-test-container"
sourceCodePath="$(pwd)/library"
sourceCodePathWorkdir="/$projectName"
targetFileGlob=$1

# Node modules volume.
nodeModulesVolumeName="$projectName-node_modules"
nodeModulesContainerPath="/node_modules"

# ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
# ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
# █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
# ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
# ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
# ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

# Pre-execution.
docker container rm "$containerName" &> /dev/null
docker image rm "$imageName" &> /dev/null

# Create the image for our test environment.
docker image build \
  --file "$dockerFilePath" \
  --tag "$imageName" \
  .

# Create an image to run a "run tests" command.
docker container run \
  --rm \
  --tty \
  -v "$nodeModulesVolumeName":"$nodeModulesContainerPath" \
  -v "$sourceCodePath":"$sourceCodePathWorkdir" \
  --name "$containerName" \
  "$imageName" \
  $targetFileGlob

# Post-execution cleanup.
docker image rm "$imageName" &> /dev/null
