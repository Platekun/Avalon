#!/bin/bash

GREEN="\033[0;32m";
END_COLOR="\033[0m";

function log() {
    echo -e "${1}";
}

log "${GREEN}[Avalon]${END_COLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}📦 Preparing to release...${END_COLOR}";

# ███████╗███████╗████████╗██╗   ██╗██████╗ 
# ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
# ███████╗█████╗     ██║   ██║   ██║██████╔╝
# ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
# ███████║███████╗   ██║   ╚██████╔╝██║     
# ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

projectName="{{projectName}}";
imageName="${projectName}-release-image";
dockerFilePath="./docker/release.Dockerfile";
containerName="${projectName}-release-container";
sourceCodePath="$(pwd)/library";
sourceCodePathWorkdir="/${projectName}";

# ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
# ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
# █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
# ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
# ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
# ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ 

# Pre-execution cleanup.
docker container rm ${containerName} &> /dev/null;
docker image rm ${imageName} &> /dev/null;

# Create an image to run a "release project" command.
docker image build \
  --file ${dockerFilePath} \
  --tag ${imageName} \
  .;

# Run the "release project" command container.
docker container run \
  --rm \
  --interactive \
  --tty \
  -v ${sourceCodePath}:${sourceCodePathWorkdir} \
  --name ${buildContainerName} \
  ${imageName};

# Post-execution cleanup.
docker image rm ${imageName} &> /dev/null;
