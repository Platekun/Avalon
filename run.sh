#!/bin/bash

# Note: Make sure you have `AVALON_PATH` as an environment variable in your shell profile. It must be an absolute path that points to this directory.

AVALON_VERSION=0.0.1;

RED="\e[31m";
GREEN="\e[32m";
BLUE="\e[34m";
ENDCOLOR="\e[0m";

# Enums
LIBRARY_ARTIFACT_TYPE="library";
GITHUB_CI_CD="github-ci-cd";
NO_CI_CD="no-ci-cd";

# License
currentYear=(date +"%Y");
authorName=$(whoami);

displayTopLevelHelpMessage() {
    echo "Usage: avalon COMMAND";
    echo ""
    echo "⚔️  A TypeScript application/library generator with opinionated defaults."
    echo ""
    echo "🏳  Options:";
    echo "    --artifact=string      Sets the software artifact type (\"library\"|\"application\").";
    echo "    --ci-cd=string            Sets the continous integration configuration (\"barebones\"|\"github-actions\").";
    echo ""
    echo "📚 Commands:";
    echo "    new      Create a new Avalon artfiact.";
    echo "    help     Display this help message.";
    echo ""
    echo "Run 'avalon COMMAND help' for more information on a command.";

    exit 0;
}

assertArtifactType() {
    artifactType=$1

    if [[ ${artifactType} != "library" && ${artifactType} != "application" ]]
    then
        echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED}An unsupported artifact type '${2}' was provided. Avalon only supported ${GREEN}'library'${ENDCOLOR} ${RED}or${ENDCOLOR} ${GREEN}'app'${ENDCOLOR} ${RED}as artifact types${ENDCOLOR}.");
        exit 1;
    fi
}

assertArtifactName() {
    artifactName=$1

    if [[ -z ${artifactName} ]]
    then
        echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED}A name for the library is required.${ENDCOLOR}");
        exit 1;
    fi
}

handleUnknownCommand() {
    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED}Command not supported. Try using ${BLUE}'avalon help'${ENDCOLOR} ${RED}command. ${ENDCOLOR}");
    exit 2;
}

createLibrary() {
    # ███████╗███████╗████████╗██╗   ██╗██████╗ 
    # ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
    # ███████╗█████╗     ██║   ██║   ██║██████╔╝
    # ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
    # ███████║███████╗   ██║   ╚██████╔╝██║     
    # ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

    artifactName=$1;
    ci=$2;
    imageName="${artifactName}-image";
    dockerfilePath="${AVALON_PATH}/docker/libraries/${ci}.Dockerfile";
    containerName="${artifactName}-container";

    # Node modules volume
    nodeModulesVolumeName="${artifactName}-node_modules";
    nodeModulesContainerPath="/node_modules";

    # Source Code
    sourceVolumeName="${artifactName}-source";
    sourceCodeContainerPath="/avalon-project";

    # ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗
    # ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║
    # █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║
    # ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║
    # ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║
    # ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Bootstrapping a new TypeScript library...${ENDCOLOR}");

    # Pre-execution cleanup
    docker container rm "${containerName}" &> /dev/null;
    docker volume rm "${sourceVolumeName}" &> /dev/null;
    docker image rm "${imageName}" &> /dev/null;

    echo "$dockerfilePath $imageName $AVALON_PATH"

    # Create an image to run a "create library" command.
    docker image build \
        --build-arg PROJECT_NAME=${artifactName} \
        --build-arg YEAR=2021 \
        --build-arg AUTHOR_NAME=${authorName} \
        --file ${dockerfilePath} \
        --tag "${imageName}" \
        ${AVALON_PATH} || \
        {
            echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed while creating an image to run a 'create library' command.");
            exit 1;
        };

    # Run the "create library" command container.
    docker container run \
        --interactive \
        --tty \
        -v "${nodeModulesVolumeName}":"${nodeModulesContainerPath}" \
        -v "${sourceVolumeName}":"${sourceCodeContainerPath}" \
        --name "${containerName}" \
        "${imageName}" \
        || {
            echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed while running a 'create library' container command.");
            exit 1;
        };

    # Copy the contents of the source code volume into a new `library` directory.
    docker cp "${containerName}":"${sourceCodeContainerPath}" "./${artifactName}" || \
    { 
        echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed while copying the contents of the source code volume into a new `library` directory.");
        exit 1;
    };

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Cleaning up...${ENDCOLOR}");

    # Post-execution cleanup
    docker volume rm "${sourceVolumeName}" &> /dev/null;
    docker container rm "${containerName}" &> /dev/null;
    docker image rm "${imageName}" &> /dev/null;

    cd ${artifactName};
    git init;
    git add --all;
    git commit -m "Initial commit from Avalon v${AVALON_VERSION}"
    cd ..;
}

createLibraryWithNoCi() {
    createLibrary $1 $2;

    successMessage="ℹ️  Inside that directory, you can run several commands from the ${BLUE}scripts${ENDCOLOR} directory:

        ${BLUE}install${ENDCOLOR}
        Installs the library dependencies (AKA your node_modules).

        ${BLUE}start-development${ENDCOLOR}
        Compiles your source code using the 🧙‍♂️ TypeScript compiler (https://www.npmjs.com/package/typescript) and re-compiles on changes.

        ${BLUE}test${ENDCOLOR}
        Starts the 🃏 Jest (https://jestjs.io) test runner.

        ${BLUE}watch-tests${ENDCOLOR}
        Starts the 🃏 Jest (https://jestjs.io) test runner and watches for changes.

        ${BLUE}format${ENDCOLOR}
        Formats your source code using 💅 Prettier (https://prettier.io).

        ${BLUE}build${ENDCOLOR}
        Compiles your source code using the 🧙‍♂️ TypeScript compiler (https://www.npmjs.com/package/typescript).

        ${BLUE}release${ENDCOLOR}
        Prompts your 📦 npm (https://www.npmjs.com) credentials to publish your package.

    💡 We suggest that you start by typing:
        ${BLUE}cd${ENDCOLOR} ${1}
        ${BLUE}bash${ENDCOLOR} scripts/start-development.sh

    🍻 Happy hacking!";

    printf "${successMessage}";
    exit 0;
}

createLibraryWithGitHubCiCd() {
    createLibrary $1 $2;

    successMessage="
    ℹ️  Inside that directory, you can run several commands from the ${BLUE}scripts${ENDCOLOR} directory:

        ${BLUE}install${ENDCOLOR}
        Installs the library dependencies (AKA your node_modules).

        ${BLUE}start-development${ENDCOLOR}
        Compiles your source code using the 🧙‍♂️ TypeScript compiler (https://www.npmjs.com/package/typescript) and re-compiles on changes.

        ${BLUE}test${ENDCOLOR}
        Starts the 🃏 Jest (https://jestjs.io) test runner.

        ${BLUE}watch-tests${ENDCOLOR}
        Starts the 🃏 Jest (https://jestjs.io) test runner and watches for changes.

        ${BLUE}format${ENDCOLOR}
        Formats your source code using 💅 Prettier (https://prettier.io).

        ${BLUE}build${ENDCOLOR}
        Compiles your source code using the 🧙‍♂️ TypeScript compiler (https://www.npmjs.com/package/typescript).

    💡 We suggest that you start by typing:
        ${BLUE}cd${ENDCOLOR} ${1}
        ${BLUE}bash${ENDCOLOR} scripts/start-development.sh

    🍻 Happy hacking!";

    printf "${successMessage}";
    exit 0;
}

displayCreateNewArtifactHelpMessage() {
    echo "Usage:  avalon new create ARTIFACT_NAME [OPTIONS] [COMMAND]";
    echo ""
    echo "🏗  Create software artifacts."
    echo ""
    echo "🏳  Options:";
    echo "    --artifact=string      Sets the software artifact type (\"library\"|\"application\").";
    echo "    --ci-cd=string            Sets the continous integration configuration (\"barebones\"|\"github-actions\").";
    echo ""
    echo "📚 Commands:";
    echo "    help      Display this help message.";
    echo ""
    echo "Run 'avalon new COMMAND help' for more information on a command.";

    exit 0;
}

handleUnknownNewCommand() {
    echo "${option} is not an Avalon command.";
    echo "See 'avalon new help'";
    exit 1;
}

createNewArtifact() {
    artifactName=$2;

    # Defaults.
    artifactType=${LIBRARY_ARTIFACT_TYPE};
    cicd=${GITHUB_CI_CD};

    for option in "$@"
    do
        case ${option} in
            help) displayCreateNewArtifactHelpMessage;;
            "--artifact=library") artifactType=${LIBRARY_ARTIFACT_TYPE};;
            "--ci-cd=barebones") cicd=${NO_CI_CD};;
            "--ci-cd=github-actions") cicd=${GITHUB_CI_CD};;
            "--"*) handleUnknownNewCommand;;
        esac
    done

    assertArtifactName ${artifactName};
    assertArtifactType ${artifactType};

    if [ ${artifactType} == ${LIBRARY_ARTIFACT_TYPE} ]
    then
        if [ ${cicd} == ${NO_CI_CD} ]
        then
            createLibraryWithNoCi ${artifactName} ${cicd};
        elif [ ${cicd} == ${GITHUB_CI_CD} ]
        then
            createLibraryWithGitHubCiCd ${artifactName} ${cicd};
        fi
    fi
}

execute() {
    topLevelCommand=$1;

    if [[ $# == 0 ]]
    then
        displayTopLevelHelpMessage;
    fi

    case ${topLevelCommand} in
        help) displayTopLevelHelpMessage;;
        new) createNewArtifact $@;;
        *) handleUnknownCommand;;
    esac
}

execute $@;
