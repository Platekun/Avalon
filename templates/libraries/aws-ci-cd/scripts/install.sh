#!/bin/bash

GREEN="\e[32m"
ENDCOLOR="\e[0m"

echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}🧰 Installing project...${ENDCOLOR}");

# ███████╗███████╗████████╗██╗   ██╗██████╗ 
# ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
# ███████╗█████╗     ██║   ██║   ██║██████╔╝
# ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
# ███████║███████╗   ██║   ╚██████╔╝██║     
# ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

projectName="{{projectName}}";
imageName="${projectName}-installation-image";
dockerFilePath="./docker/install.Dockerfile";
containerName="${projectName}-installation-container";

# Node modules volume.
nodeModulesVolumeName="${projectName}-node_modules";
nodeModulesContainerPath="/node_modules";

# ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
# ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
# █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
# ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
# ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
# ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ 

# Pre-execution cleanup.
docker container rm ${containerName} &> /dev/null;
docker volume rm ${nodeModulesVolumeName} &> /dev/null;
docker image rm ${imageName} &> /dev/null;

# Create an image to run a "install project" command.
docker image build \
  --file ${dockerFilePath} \
  --tag ${imageName} \
  .;

# Run the "install project" command container.
docker container run \
  --rm \
  --tty \
  -v ${nodeModulesVolumeName}:${nodeModulesContainerPath} \
  --name ${containerName} \
  ${imageName};

# Post-execution cleanup.
docker container rm "${containerName}" &> /dev/null;
docker image rm "${imageName}" &> /dev/null;
 