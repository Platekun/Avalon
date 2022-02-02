#!/bin/bash

GREEN="\e[32m"
ENDCOLOR="\e[0m"

echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}🌎 Preparing to release...${ENDCOLOR}")

# ███████╗███████╗████████╗██╗   ██╗██████╗ 
# ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
# ███████╗█████╗     ██║   ██║   ██║██████╔╝
# ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
# ███████║███████╗   ██║   ╚██████╔╝██║     
# ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

projectName="{{projectName}}"
imageName="${projectName}-release-image"
dockerFilePath="./docker/release.Dockerfile"
containerName="${projectName}-release-container"
sourceCodePath="$(pwd)/library"
sourceCodePathWorkdir="/${projectName}"

# ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
# ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
# █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
# ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
# ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
# ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ 

# Pre-execution cleanup.
docker container rm "${containerName}" &> /dev/null
docker image rm "${imageName}" &> /dev/null

# Create an image to run a "release project" command.
docker image build \
  --file "${dockerFilePath}" \
  --tag "${imageName}" \
  .

# Run the "release project" command container.
docker container run \
  --rm \
  --interactive \
  --tty \
  -v "${sourceCodePath}":"${sourceCodePathWorkdir}" \
  --name "${buildContainerName}" \
  "${imageName}"

# Post-execution cleanup.
docker image rm "${imageName}" &> /dev/null
