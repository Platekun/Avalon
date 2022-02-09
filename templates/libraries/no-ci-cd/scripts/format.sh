#!/bin/bash

GREEN="\033[0;32m";
END_COLOR="\033[0m";

function log() {
    echo -e "${1}";
}

log "${GREEN}[Avalon]${END_COLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}💅 Running formatter...${END_COLOR}";

# ███████╗███████╗████████╗██╗   ██╗██████╗ 
# ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
# ███████╗█████╗     ██║   ██║   ██║██████╔╝
# ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
# ███████║███████╗   ██║   ╚██████╔╝██║     
# ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

projectName="{{projectName}}";
imageName="${projectName}-format-image";
dockerFilePath="./docker/format.Dockerfile";
containerName="${projectName}-format-container";
sourceCodePath="$(pwd)/library";
sourceCodePathWorkdir="/${projectName}";

# Node modules volume.
nodeModulesVolumeName="${projectName}-node_modules";
nodeModulesContainerPath="/node_modules";

# ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
# ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
# █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
# ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
# ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
# ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ 

# Pre-execution cleanup
docker container rm ${containerName} &> /dev/null;
docker image rm ${imageName} &> /dev/null;

# Create an image to run a "format project" command.
docker image build \
  --file ${dockerFilePath} \
  --tag ${imageName} \
  .;

# Run the "format project" command container.
docker container run \
  --rm \
  --tty \
  -v ${nodeModulesVolumeName}:${nodeModulesContainerPath} \
  -v ${sourceCodePath}:${sourceCodePathWorkdir} \
  --name ${containerName} \
  ${imageName};

# Post-execution
docker image rm ${imageName} &> /dev/null;
