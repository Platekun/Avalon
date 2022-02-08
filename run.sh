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
AWS_CI_CD="aws-ci-cd";
AWS_NPM_AUTH_TOKEN_SECRET_NAME="AVALON_NPM_AUTH_TOKEN";

# License
CURRENT_YEAR=$(date +"%Y");
AUTHOR_NAME=$(whoami);

function handleInstallCommand() {
    if [[ $# == 1 ]]
    then
        bash ./scripts/install.sh;
    else
        command=${2};

        case ${command} in
            help) 
                echo "Usage:  avalon install";
                echo "";
                echo "🛠  Install your project dependencies.";
                echo "";
                echo "📚 Commands:";
                echo "    help      Display this help message.";
                echo "";
                echo "Run 'avalon install COMMAND help' for more information on a command.";

                exit 0;;
            *) handleUnknownCommand;;
        esac
    fi
}

function handleDevelopCommand() {
    if [[ $# == 1 ]]
    then
        bash ./scripts/start-development.sh;
    else
        command=${2};

        case ${command} in
            help) 
            echo "Usage:  avalon develop";
            echo "";
            echo "🔥 Spin up a development environment.";
            echo "";
            echo "📚 Commands:";
            echo "    help      Display this help message.";
            echo "";
            echo "Run 'avalon develop COMMAND help' for more information on a command.";

            exit 0;;
            *) handleUnknownCommand;;
        esac
    fi
}

function handleTestCommand() {
    bash ./scripts/test.sh ${1};
}

function handleWatchTestsCommand() {
    if [[ $# == 1 ]]
    then
        bash ./scripts/watch-tests.sh;
    else
        command=${2};

        case ${command} in
            help) handleTestCommand "help";;
            *) handleUnknownCommand;;
        esac
    fi
}

function handleFormatCommand() {
    if [[ $# == 1 ]]
    then
        bash ./scripts/format.sh;
    else
        command=${2};

        case ${command} in
            help) 
                echo "Usage:  avalon format";
                echo "";
                echo "💅 Format your source code."
                echo "";
                echo "📚 Commands:";
                echo "    help      Display this help message.";
                echo "";
                echo "Run 'avalon format COMMAND help' for more information on a command.";

                exit 0;;
            *) handleUnknownCommand;;
        esac
    fi
}

function handleBuildCommand() {
    if [[ $# == 1 ]]
    then
        bash ./scripts/build.sh;
    else
        command=${2};

        case ${command} in
            help) 
                echo "Usage:  avalon build";
                echo "";
                echo "🧙‍♂️ Compile your source code."
                echo "";
                echo "📚 Commands:";
                echo "    help      Display this help message.";
                echo "";
                echo "Run 'avalon build COMMAND help' for more information on a command.";

                exit 0;;
            *) handleUnknownCommand;;
        esac
    fi
}

function handleReleaseCommand() {
    isABareBonesLibrary=$(grep -e "\"ci-cd\": \"barebones\"" ".avaloncli.json");

    if [[ -n ${isABareBonesLibrary} ]]
    then
        if [[ $# == 1 ]]
        then
            bash ./scripts/release.sh;
        else
            command=${2};

            case ${command} in
                help) 
                    echo "Usage:  avalon release";
                    echo "";
                    echo "📦 Release your software to the world."
                    echo "";
                    echo "📚 Commands:";
                    echo "    help      Display this help message.";
                    echo "";
                    echo "Run 'avalon release COMMAND help' for more information on a command.";

                    exit 0;;
                *) handleUnknownCommand;;
            esac
        fi
    else
        echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED}Command not supported for this type of artifact. The ${BLUE}'avalon release'${ENDCOLOR} ${RED}command is only available for Avalon barebones libraries.${ENDCOLOR}");
        exit 2;
    fi
}

function handleHelpCommand() {
    echo "Usage: avalon COMMAND";
    echo ""
    echo "⚔️  A TypeScript application/library generator with opinionated defaults."
    echo ""
    echo "📚 Commands:";
    echo "    destroy       Remove an avalon project form your machine.";
    echo "    install       Install your project dependencies.";
    echo "    develop       Spin up a development environment.";
    echo "    test          Execute the test runner.";
    echo "    watch-tests   Execute the test runner and watch for changes.";
    echo "    format        Format your source code.";
    echo "    build         Compile your source code.";
    echo "    release       Release your software to the world.";
    echo "    new           Create a new Avalon artifact.";
    echo "    help          Display this help message.";
    echo ""
    echo "Run 'avalon COMMAND help' for more information on a command.";

    exit 0;
}

function assertArtifactType() {
    artifactType=${1};

    if [[ ${artifactType} != "library" && ${artifactType} != "application" ]]
    then
        echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED}An unsupported artifact type '${2}' was provided. Avalon only supported ${GREEN}'library'${ENDCOLOR} ${RED}or${ENDCOLOR} ${GREEN}'app'${ENDCOLOR} ${RED}as artifact types${ENDCOLOR}.");
        exit 1;
    fi
}

function assertArtifactName() {
    artifactName=${1};

    if [[ -z ${artifactName} ]]
    then
        echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED}A name for the library is required.${ENDCOLOR}");
        exit 1;
    fi
}

function rollback() {
    artifactName=${1};
    imageName="${artifactName}-image";
    containerName="${artifactName}-container";
    sourceVolumeName="${artifactName}-source";

    rm -rf ${artifactName};
    gh repo delete ${artifactName};
    docker container rm "${containerName}" &> /dev/null;
    docker volume rm "${sourceVolumeName}" &> /dev/null;
    docker image rm "${imageName}" &> /dev/null;
    aws cloudformation delete-stack --stack-name=${artifactName};
}

function createLibraryWithNoCiCd() {
    # Parameters.
    artifactName=${1};
    cicd=${2};
    repositoryUrl=${3};

    # Docker - general.
    imageName="${artifactName}-image";
    dockerfilePath="${AVALON_PATH}/docker/libraries/${cicd}.Dockerfile";
    containerName="${artifactName}-container";

    # Docker - Node modules volume.
    nodeModulesVolumeName="${artifactName}-node_modules";
    nodeModulesContainerPath="/node_modules";

    # Docker - Source Code.
    sourceVolumeName="${artifactName}-source";
    sourceCodeContainerPath="/avalon-project";

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Bootstrapping a new TypeScript library...${ENDCOLOR}");

    # Pre-execution cleanup
    docker container rm "${containerName}" &> /dev/null;
    docker volume rm "${sourceVolumeName}" &> /dev/null;
    docker image rm "${imageName}" &> /dev/null;

    echo "$dockerfilePath $imageName $AVALON_PATH"

    # Create an image to run a "create library" command.
    docker image build \
        --build-arg PROJECT_NAME=${artifactName} \
        --build-arg YEAR=${CURRENT_YEAR} \
        --build-arg AUTHOR_NAME=${AUTHOR_NAME} \
        --file ${dockerfilePath} \
        --tag "${imageName}" \
        ${AVALON_PATH} || \
        {
            echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed while creating an image to run a 'create library' command.");
            rollback ${artifactName};
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
            rollback ${artifactName};
            exit 1;
        };

    # Copy the contents of the source code volume into a new `library` directory.
    docker cp "${containerName}":"${sourceCodeContainerPath}" "./${artifactName}" || \
    { 
        echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed while copying the contents of the source code volume into a new `library` directory.");
        rollback ${artifactName};
        exit 1;
    };

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Setting up version control...${ENDCOLOR}");

    # Setup version control.
    cd ${artifactName};
    git init;
    git add --all;
    git commit -m "Initial commit from Avalon v${AVALON_VERSION}";
    git remote add origin ${repositoryUrl};
    git push -u origin main;
    git checkout -b dev;
    git push -u origin dev;

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Cleaning up...${ENDCOLOR}");

    # Post-execution cleanup.
    docker volume rm "${sourceVolumeName}" &> /dev/null;
    docker container rm "${containerName}" &> /dev/null;
    docker image rm "${imageName}" &> /dev/null;

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Success!${ENDCOLOR} Bootstrapped ${artifactName} at \"$(pwd)/${artifactName}.\"")

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

    🚏 Additionally, a new set of resources was created:

        🐙 Your artifact's GitHub repository is: ${repositoryUrl}.

    💡 We suggest that you start by typing:
        ${BLUE}cd${ENDCOLOR} ${1}
        ${BLUE}bash${ENDCOLOR} scripts/start-development.sh

    🍻 Happy hacking!
";

    printf "${successMessage}";
    exit 0;
}

function createLibraryWithGitHubCiCd() {
    # Parameters.
    artifactName=${1};
    cicd=${2};
    repositoryUrl=${3};

    # Docker - general.
    imageName="${artifactName}-image";
    dockerfilePath="${AVALON_PATH}/docker/libraries/${cicd}.Dockerfile";
    containerName="${artifactName}-container";

    # Docker - Node modules volume.
    nodeModulesVolumeName="${artifactName}-node_modules";
    nodeModulesContainerPath="/node_modules";

    # Docker - Source Code.
    sourceVolumeName="${artifactName}-source";
    sourceCodeContainerPath="/avalon-project";

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Bootstrapping a new TypeScript library with a GitHub Actions CI/CD pipeline...${ENDCOLOR}");

    # Pre-execution cleanup
    docker container rm "${containerName}" &> /dev/null;
    docker volume rm "${sourceVolumeName}" &> /dev/null;
    docker image rm "${imageName}" &> /dev/null;

    # Create an image to run a "create library" command.
    docker image build \
        --build-arg PROJECT_NAME=${artifactName} \
        --build-arg YEAR=${CURRENT_YEAR} \
        --build-arg AUTHOR_NAME=${AUTHOR_NAME} \
        --file ${dockerfilePath} \
        --tag "${imageName}" \
        ${AVALON_PATH} || \
        {
            echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed while creating an image to run a 'create library' command.");
            rollback ${artifactName};
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
            rollback ${artifactName};
            exit 1;
        };

    # Copy the contents of the source code volume into a new `library` directory.
    docker cp "${containerName}":"${sourceCodeContainerPath}" "./${artifactName}" || \
    { 
        echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed while copying the contents of the source code volume into a new `library` directory.");
        rollback ${artifactName};
        exit 1;
    };

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Setting up version control...${ENDCOLOR}");

    # Setup version control.
    cd ${artifactName};
    git init;
    git add --all;
    git commit -m "Initial commit from Avalon v${AVALON_VERSION}";
    git remote add origin ${repositoryUrl};
    git push -u origin main;
    git checkout -b dev;
    git push -u origin dev;
    cd ..;

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Cleaning up...${ENDCOLOR}");

    # Post-execution cleanup.
    docker volume rm "${sourceVolumeName}" &> /dev/null;
    docker container rm "${containerName}" &> /dev/null;
    docker image rm "${imageName}" &> /dev/null;

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Success!${ENDCOLOR} Bootstrapped ${artifactName} at \"$(pwd)/${artifactName}.\"")

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

    🚏 Additionally, a new set of resources was created:

        🐙 Your artifact's GitHub repository is: ${repositoryUrl}.

    💡 We suggest that you start by typing:
        ${BLUE}cd${ENDCOLOR} ${1}
        ${BLUE}bash${ENDCOLOR} scripts/start-development.sh

    🍻 Happy hacking!
";

    printf "${successMessage}";
    exit 0;
}

function createLibraryWithAwsCiCd() {
    # Parameters.
    artifactName=${1};
    cicd=${2};
    repositoryUrl=${3};

    # Docker - general.
    imageName="${artifactName}-image";
    dockerfilePath="${AVALON_PATH}/docker/libraries/${cicd}.Dockerfile";
    containerName="${artifactName}-container";

    # Docker - Node modules volume.
    nodeModulesVolumeName="${artifactName}-node_modules";
    nodeModulesContainerPath="/node_modules";

    # Docker - Source Code.
    sourceVolumeName="${artifactName}-source";
    sourceCodeContainerPath="/avalon-project";

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Bootstrapping a new TypeScript library with an AWS CI/CD pipeline...${ENDCOLOR}");

    # Pre-execution cleanup.
    docker container rm "${containerName}" &> /dev/null;
    docker volume rm "${sourceVolumeName}" &> /dev/null;
    docker image rm "${imageName}" &> /dev/null;

    # Retrieve the ARN of your npm authorization token residing in AWS Secrets Manager.
    AWS_NPM_AUTH_TOKEN_SECRET_ARN=$(aws secretsmanager get-secret-value --secret-id=${AWS_NPM_AUTH_TOKEN_SECRET_NAME} --query="ARN" --output text) || \
        {
            echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed to retrieve the ARN of your npm authorization token. Please make sure you have a secret with the name \"${AWS_NPM_AUTH_TOKEN_SECRET_NAME}\" stored in your AWS Secrets Manager.");
            rollback ${artifactName};
            exit 1;
        };

    # Create an image to run a "create library" command.
    docker image build \
        --build-arg PROJECT_NAME=${artifactName} \
        --build-arg YEAR=${CURRENT_YEAR} \
        --build-arg AUTHOR_NAME=${AUTHOR_NAME} \
        --build-arg AWS_NPM_AUTH_TOKEN_SECRET_ARN=${AWS_NPM_AUTH_TOKEN_SECRET_ARN} \
        --file ${dockerfilePath} \
        --tag "${imageName}" \
        ${AVALON_PATH} || \
        {
            echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed while creating an image to run a 'create library' command.");
            rollback ${artifactName};
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
            rollback ${artifactName};
            exit 1;
        };

    # Copy the contents of the source code volume into a new `library` directory.
    docker cp "${containerName}":"${sourceCodeContainerPath}" "./${artifactName}" || \
    { 
        echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed while copying the contents of the source code volume into a new `library` directory.");
        rollback ${artifactName};
        exit 1;
    };

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Setting up version control...${ENDCOLOR}");

    # Setup version control.
    cd ${artifactName};
    git init;
    git add --all;
    git commit -m "Initial commit from Avalon v${AVALON_VERSION}";
    git remote add origin ${repositoryUrl};
    git push -u origin main;
    git checkout -b dev;
    git push -u origin dev;

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Creating AWS CI/CD infrastructure...${ENDCOLOR}");

    # Create CI/CD infrastructure.
    aws cloudformation deploy \
        --template-file ./aws/ci-cd.template.json \
        --stack-name ${artifactName} \
        --capabilities CAPABILITY_NAMED_IAM \
        --parameter-overrides GitHubRepositoryUrl=${repositoryUrl} NpmAuthTokenSecretArn=${AWS_NPM_AUTH_TOKEN_SECRET_ARN} || \
        {
            echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed while CI/CD pipeline in AWS.");
            cd ..;
            rollback ${artifactName};
            exit 1;
        };

    cd ..;

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Cleaning up...${ENDCOLOR}");

    # Post-execution cleanup.
    docker volume rm "${sourceVolumeName}" &> /dev/null;
    docker container rm "${containerName}" &> /dev/null;
    docker image rm "${imageName}" &> /dev/null;

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Success!${ENDCOLOR} Bootstrapped ${artifactName} at \"$(pwd)/${artifactName}.\"")

    awsRegion=$(aws configure get region);
    awsAccountId=$(aws sts get-caller-identity --query "Account" --output text);

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

    🚏 Additionally, a new set of resources was created:

        🐙 Your artifact's GitHub repository is: ${repositoryUrl}.

        ☁️  Your CI CodeBuild project is: https://${awsRegion}.console.aws.amazon.com/codesuite/codebuild/${awsAccountId}/projects/${artifactName}-DevelopmentBuild/history?region=${awsRegion}.

        ☁️  Your CD CodeBuild project is: https://${awsRegion}.console.aws.amazon.com/codesuite/codebuild/${awsAccountId}/projects/${artifactName}-ProductionBuild/history?region=${awsRegion}.

    💡 We suggest that you start by typing:
        ${BLUE}cd${ENDCOLOR} ${1}
        ${BLUE}bash${ENDCOLOR} scripts/start-development.sh

    🍻 Happy hacking!
";

    printf "${successMessage}";
    exit 0;
}

function handleNewCommand() {
    artifactName=${2};

    # Defaults.
    artifactType=${LIBRARY_ARTIFACT_TYPE};
    cicd=${GITHUB_CI_CD};

    for option in "$@"
    do
        case ${option} in
            help)
                echo "Usage:  avalon new create ARTIFACT_NAME [OPTIONS] [COMMAND]";
                echo ""
                echo "🏗  Create software artifacts."
                echo ""
                echo "🏳  Options:";
                echo "    --artifact=string      Sets the software artifact type (\"library\"|\"application\").";
                echo "    --ci-cd=string         Sets the continous integration configuration (\"barebones\"|\"github-actions\"|\"aws\").";
                echo ""
                echo "📚 Commands:";
                echo "    help      Display this help message.";
                echo ""
                echo "Run 'avalon new COMMAND help' for more information on a command.";

                exit 0;;
            "--artifact=library") artifactType=${LIBRARY_ARTIFACT_TYPE};;
            "--ci-cd=barebones") cicd=${NO_CI_CD};;
            "--ci-cd=github-actions") cicd=${GITHUB_CI_CD};;
            "--ci-cd=aws") cicd=${AWS_CI_CD};;
            "--"*)
                echo "${option} is not an Avalon command.";
                echo "See 'avalon new help'";

                exit 1;;
        esac
    done

    assertArtifactName ${artifactName};
    assertArtifactType ${artifactType};

    gh repo create ${artifactName} --private || \
        {
            echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED} Bootstrap Error. Failed while creating a attempting to create GitHub Repository. Make sure GitHub CLI is properly configured with your credentials.");
            rollback ${artifactName};
            exit 1;
        };

    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${GREEN}Creating new GitHub repository for ${artifactName}...${ENDCOLOR}");

    repositoryUrl=$(gh repo view ${artifactName} --json "url"  --jq ".url");

    if [[ ${artifactType} == ${LIBRARY_ARTIFACT_TYPE} ]]
    then
        if [[ ${cicd} == ${NO_CI_CD} ]]
        then
            createLibraryWithNoCiCd ${artifactName} ${cicd} ${repositoryUrl};
        elif [[ ${cicd} == ${GITHUB_CI_CD} ]]
        then
            createLibraryWithGitHubCiCd ${artifactName} ${cicd} ${repositoryUrl};
        elif [[ ${cicd} == ${AWS_CI_CD} ]]
        then
            createLibraryWithAwsCiCd ${artifactName} ${cicd} ${repositoryUrl};
        fi
    fi
}

function handleDestroyCommand() {
    if [[ $# == 1 ]]
    then
        echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED}The name of the artifact is required.${ENDCOLOR}");
        exit 1;
    else
        command=${2};

        case ${command} in
            help) 
                echo "Usage:  avalon destroy";
                echo "";
                echo "🗑  Remove an avalon project form your machine thoroughly (Directories, Containers, Volumes, Repositories and AWS infrastructure).";
                echo "";
                echo "📚 Commands:";
                echo "    help      Display this help message.";
                echo "";
                echo "Run 'avalon destroy COMMAND help' for more information on a command.";

                exit 0;;
            *) 
                artifactName=${2};
                imageName="${artifactName}-image";
                containerName="${artifactName}-container";
                sourceVolumeName="${artifactName}-source";

                rm -rf ${artifactName};
                gh repo delete ${artifactName};
                docker container rm "${containerName}" &> /dev/null;
                docker volume rm "${sourceVolumeName}" &> /dev/null;
                docker image rm "${imageName}" &> /dev/null;
                aws cloudformation delete-stack --stack-name=${artifactName};
            ;;
        esac
    fi
}

function handleUnknownCommand() {
    echo $(printf "${GREEN}[Avalon]${ENDCOLOR} - $(date +"%m-%d-%Y, %r") - ${RED}Command not supported. Try using ${BLUE}'avalon help'${ENDCOLOR} ${RED}command. ${ENDCOLOR}");
    exit 2;
}

function bootstrap() {
    if [[ $# == 0 ]]
    then
        handleHelpCommand;
    fi

    command=${1};

    case ${command} in
        install) handleInstallCommand $@;;
        develop) handleDevelopCommand $@;;
        test) handleTestCommand ${2};;
        watch-tests) handleWatchTestsCommand $@;;
        format) handleFormatCommand $@;;
        build) handleBuildCommand $@;;
        release) handleReleaseCommand $@;;
        help) handleHelpCommand $@;;
        new) handleNewCommand $@;;
        destroy) handleDestroyCommand $@;;
        *) handleUnknownCommand;;
    esac
}

bootstrap $@;
