#!/bin/bash

GREEN="\e[32m"
ENDCOLOR="\e[0m"

echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}🚥 Running tests...${ENDCOLOR}")

# ███████╗███████╗████████╗██╗   ██╗██████╗ 
# ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
# ███████╗█████╗     ██║   ██║   ██║██████╔╝
# ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
# ███████║███████╗   ██║   ╚██████╔╝██║     
# ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

projectName="{{projectName}}"
testImageName="${projectName}-test-image"
testDockerFilePath="./docker/watch-tests.Dockerfile"
testContainerName="${projectName}-test-container"
sourceCodePath="$(pwd)/library"
sourceCodePathWorkdir="/${projectName}"

# Git volume.
gitVolumePath="$(pwd)/.git"
gitContainerPath="/${projectName}/.git"

# Node modules volume.
nodeModulesVolumeName="${projectName}-node_modules"
nodeModulesContainerPath="/node_modules"

# ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
# ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
# █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
# ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
# ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
# ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

# Pre-execution cleanup.
docker container rm "${testContainerName}" &> /dev/null
docker image rm "${testImageName}" &> /dev/null

# Create an image to run a "start development mode" command.
docker image build \
  --file "${testDockerFilePath}" \
  --tag "${testImageName}" \
  .

# Create an image to run a "run tests" command.
docker container run \
  --rm \
  --interactive \
  --tty \
  -v "${nodeModulesVolumeName}":"${nodeModulesContainerPath}" \
  -v "${sourceCodePath}":"${sourceCodePathWorkdir}" \
  -v "${gitVolumePath}":"${gitContainerPath}" \
  --name "${testContainerName}" \
  "${testImageName}"

# Post-execution cleanup
docker image rm "${testImageName}" &> /dev/null
