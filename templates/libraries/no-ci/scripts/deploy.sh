#!/bin/bash

GREEN="\e[32m"
ENDCOLOR="\e[0m"

echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}🌎 Preparing to deploy...${ENDCOLOR}")

# ███████╗███████╗████████╗██╗   ██╗██████╗ 
# ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
# ███████╗█████╗     ██║   ██║   ██║██████╔╝
# ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
# ███████║███████╗   ██║   ╚██████╔╝██║     
# ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

projectName="{{projectName}}"
deploymentImageName="${projectName}-deployment-image"
deploymentDockerFilePath="./docker/deploy.Dockerfile"
deploymentContainerName="${projectName}-deployment-container"
sourceCodePath="$(pwd)/library"
sourceCodePathWorkdir="/${projectName}"

# ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
# ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
# █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
# ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
# ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
# ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ 

# Pre-execution cleanup.
docker container rm "${deploymentContainerName}" &> /dev/null
docker image rm "${deploymentImageName}" &> /dev/null

# Create an image to run a "deploy project" command.
docker image build \
  --file "${deploymentDockerFilePath}" \
  --tag "${deploymentImageName}" \
  .

# Run the "deploy project" command container.
docker container run \
  --rm \
  --interactive \
  --tty \
  -v "${sourceCodePath}":"${sourceCodePathWorkdir}" \
  --name "${buildContainerName}" \
  "${deploymentImageName}"

# Post-execution cleanup.
docker image rm "${deploymentImageName}" &> /dev/null
