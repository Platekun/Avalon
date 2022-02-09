#!/bin/bash

GREEN="\033[0;32m";
END_COLOR="\033[0m";

function log() {
    echo -e "${1}";
}

log "${GREEN}[Avalon]${END_COLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}🚥 Executing test runner...${END_COLOR}";

# ███████╗███████╗████████╗██╗   ██╗██████╗ 
# ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
# ███████╗█████╗     ██║   ██║   ██║██████╔╝
# ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
# ███████║███████╗   ██║   ╚██████╔╝██║     
# ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

projectName="{{projectName}}";
imageName="${projectName}-test-image";
dockerFilePath="./docker/test.Dockerfile";
containerName="${projectName}-test-container";
targetFileGlob=${1};

# Node modules volume.
nodeModulesVolumeName="${projectName}-node_modules";
nodeModulesContainerPath="/node_modules";

# ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
# ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
# █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
# ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
# ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
# ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

# Pre-execution.
docker container rm ${containerName} &> /dev/null;
docker image rm ${imageName} &> /dev/null;

# Create an image to run a "execute test runner" command.
docker image build \
  --file ${dockerFilePath} \
  --tag ${imageName} \
  .;

# Run the "Execute test runner" command container.
docker container run \
  --rm \
  --tty \
  -v ${nodeModulesVolumeName}:${nodeModulesContainerPath} \
  --name ${containerName} \
  ${imageName} \
  ${targetFileGlob};

# Post-execution cleanup.
docker image rm ${imageName} &> /dev/null;
