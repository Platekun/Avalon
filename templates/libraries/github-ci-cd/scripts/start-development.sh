#!/bin/bash

GREEN="\e[32m";
ENDCOLOR="\e[0m";

echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}🔥 Starting project in development mode...${ENDCOLOR}");

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
