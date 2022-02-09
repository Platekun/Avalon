#!/bin/bash

GREEN="\033[0;32m";
END_COLOR="\033[0m";

function log() {
    echo -e "${1}";
}

log "${GREEN}[Avalon]${END_COLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}🔥 Starting project in development mode...${END_COLOR}";

# ███████╗███████╗████████╗██╗   ██╗██████╗ 
# ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
# ███████╗█████╗     ██║   ██║   ██║██████╔╝
# ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
# ███████║███████╗   ██║   ╚██████╔╝██║     
# ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

projectName="{{projectName}}";
imageName="${projectName}-development-image";
dockerFilePath="./docker/start-development.Dockerfile";
containerName="${projectName}-development-container";
sourceCodePath="$(pwd)/library";
sourceCodePathWorkdir="/${projectName}";

# Node modules volume.
nodeModulesVolumeName="${projectName}-node_modules";
nodeModulesContainerPath="/${projectName}/node_modules";

# ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
# ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
# █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
# ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
# ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
# ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

# Pre-execution cleanup.
docker container rm ${containerName} &> /dev/null;

# Create an image to run a "start development mode" command.
docker image build \
  --file ${dockerFilePath} \
  --tag ${imageName} \
  .;

# Run the "start development mode" command container.
docker container run \
  --rm \
  --interactive \
  --tty \
  -v ${nodeModulesVolumeName}:${nodeModulesContainerPath} \
  -v ${sourceCodePath}:${sourceCodePathWorkdir} \
  --name ${containerName} \
  ${imageName};
