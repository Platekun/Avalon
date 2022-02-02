#!/bin/bash

GREEN="\e[32m"
ENDCOLOR="\e[0m"

echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}🏗  Building project...${ENDCOLOR}")

# ███████╗███████╗████████╗██╗   ██╗██████╗ 
# ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
# ███████╗█████╗     ██║   ██║   ██║██████╔╝
# ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
# ███████║███████╗   ██║   ╚██████╔╝██║     
# ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

projectName="{{projectName}}"
imageName="${projectName}-build-image"
dockerFilePath="./docker/build.Dockerfile"
containerName="${projectName}-build-container"
sourceCodePath="$(pwd)/library"
sourceCodePathWorkdir="/${projectName}"

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
docker container rm "${containerName}" &> /dev/null
docker image rm "${imageName}" &> /dev/null

# Create an image to run a "build project" command.
docker image build \
  --file "${dockerFilePath}" \
  --tag "${imageName}" \
  .

# Run the "build project" command container.
docker container run \
  --rm \
  --tty \
  -v "${nodeModulesVolumeName}":"${nodeModulesContainerPath}" \
  -v "${sourceCodePath}":"${sourceCodePathWorkdir}" \
  --name "${containerName}" \
  "${imageName}"

# Post-execution cleanup.
docker image rm "${imageName}" &> /dev/null
