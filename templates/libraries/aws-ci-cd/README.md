# Getting Started with Avalon

```
                                                        ~
                                    ~                '
                                      `        (O)       ~
                                                H      '
                                ~               H
                                  `        ____hHh____
                                    ~      `---------'    ~
                                      `       | | |     '
                                              | | |
                                              | | |
                                              | | |
                                              | | |
                                              | | |
                                              | | |
                                              | | |
                                        _____;~~~~~:____
                                      __'                \
                                    /         \          |
                                    |    _\\_   |         |\
                                    |     \\    |         | |      ___
                            __    /     __     |         | |    _/   \
                            /__\  |_____/__\____|_________|__\  /__\___\
```

This project was bootstrapped with Avalon.

## Project Structure

```
root
├── .avaloncli.json.....................................................Avalon CLI configuration file. Contains metadata about the artifact (Internal).
├── .gitignore..........................................................Filters out unnecesary files from your Git commits.
├── README.md...........................................................README of your project.
├── aws.................................................................AWS related files.
│   ├── buildspec.cd.yml................................................Development CodeBuild project configuration file (CD Step).
│   ├── buildspec.ci.yml................................................Production CodeBuild project configuration file (CI Step).
│   ├── ci-cd.template.yml..............................................CloudFormation template used to provide the infrastructure of this artifact.
├── docker..............................................................Dockerfiles to execute commands (Use them via scripts).
│   ├── build.Dockerfile................................................Dockerfile used to execute to compile the project using TypeScript.
│   ├── release.Dockerfile..............................................Dockerfile used to execute to release to npm.
│   ├── format.Dockerfile...............................................Dockerfile used run prettier.
│   ├── install.Dockerfile..............................................Dockerfile used to install the node_modules of the project.
│   ├── start-development.Dockerfile....................................Dockerfile used to compile to compile the project using TypeScript and watch for changes.
│   ├── test.Dockerfile.................................................Dockerfile used to execute the test runner.
│   └── watch-tests.Dockerfile..........................................Dockerfile used to execute the test runner and watch for changes.
├── library
    ├── .prettierignore.................................................Filters out files that won't be formatted.
    ├── .prettierrc.json................................................File formatter.
│   ├── LICENSE.........................................................Software License.
│   ├── jest.config.js..................................................Test runner configuration.
│   ├── package.json....................................................Defines name, version and project dependencies.
│   ├── source..........................................................Actual library source code.
│   │   ├── environment.d.ts............................................Global typings.
│   │   └── index.ts....................................................Source code entrypoint.
│   ├── test............................................................Tests directory.
│   │   └── index.test.ts
│   ├── tsconfig.json...................................................TypeScript compiler configuration.
│   └── tsconfig.production.json........................................TypeScript compiler configuration for releasement.
└── scripts.............................................................Bash scripts used to interact with the codebase. It uses the docker directory files under the hood.
    ├── build.sh........................................................Script to build the project.
    ├── release.sh......................................................Script to release the project.
    ├── format.sh.......................................................Script to format the project.
    ├── install.sh......................................................Script to install the project.
    ├── start-development.sh............................................Script to start development.
    ├── test.sh.........................................................Script to tests.
    └── watch-tests.sh..................................................Script to watch tests.
```

## Scripts

In the project directory, you can run:

After creating our project, you will find several commands inside an `scripts` directory:

### Installation

Installs the library dependencies (AKA your node_modules):

```shell
bash ./scripts/install.sh
```

alternatively you can run the script using the Avalon CLI:

```shell
avalon install
```

### Development

Compiles your source code using the [🧙‍♂️ TypeScript compiler](https://www.npmjs.com/package/typescript) and re-compiles on changes:

```shell
bash ./scripts/start-development.sh
```

alternatively you can run the script using the Avalon CLI:

```shell
avalon develop
```

### Tests

Executes the [🃏 Jest](https://jestjs.io) test runner:

```shell
bash ./scripts/test.sh
```

alternatively you can run the script using the Avalon CLI:

```shell
avalon test
```

**Note**: 💡 You can use a custom test file path as well:

```shell
bash ./scripts/test.sh tests/some-test.spec.ts
```

```shell
avalon test tests/some-test.spec.ts
```

### Watch Tests

Executes the [🃏 Jest](https://jestjs.io) test runner and watches for changes:

```shell
bash ./scripts/watch-tests
```

alternatively you can run the script using the Avalon CLI:

```shell
avalon watch-tests
```

### Formatting

Formats your source code using [💅 Prettier](https://prettier.io):

```shell
bash ./scripts/format.sh
```

alternatively you can run the script using the Avalon CLI:

```shell
avalon format
```

### Building

Compiles your source code using the [🧙‍♂️ TypeScript compiler](https://www.npmjs.com/package/typescript):

```shell
bash ./scripts/build.sh
```

alternatively you can run the script using the Avalon CLI:

```shell
avalon build
```

## Git Hooks

Git hooks are a mean to fire off custom scripts when certain important actions occur while performing [🌳 Git](https://git-scm.com) actions. Git hooks are located in the `.git/hooks` where each file represents a different hook.

Avalon sets up two client-side hooks:

- `pre-commit`: Will format files before `git commit`.
- `pre-push`:
  - Will prevent any `git push` action to `master`/`main`/`dev` branches.
  - Will format files before `git push`.

## CI/CD

CI/CD is a modern software development practice in which incremental changes are made frequently and then the code is delivered quickly. It is a way to provide value to customers efficientlly by using automations to shorten the release cycles.

### Continous Integration

The CI (Continous Integration) part is about integrating changes into our system in a safe way.

Source code needs to live in a centralized repository where developers will constantly push code.

A dedicated server will know when code is pushed to this repository and will check the source code by building the project and running its tests.

The build server will send the results to the responsible developer when they are ready, closing the loop of feedback.

#### Usage

Avalon sets up a development [CodeBuild](https://aws.amazon.com/codebuild/) project for this purpose. The name of the CodeBuild project is `<<artifact-name>>DevelopmentBuild`. where `<<artifact-name>>` is the name you passed when creating the artifact when using `avalon new`.

To perform the CI step in your project, you only need to push code to the repository.

#### How It Works

1. Changes are pushed to the GitHub repository.
2. The development CodeBuild project will trigger a new build. It makes use of the `buildspec.ci.yml` file.
3. The `install` phase executes some commands needed to use Docker without problems.
4. The `build` phase executes the `scripts/ci.sh` script which builds a Docker image using the `docker/ci.Dockerfile` Dockerfile.
5. When building the Docker image, the project is copied and built inside the Docker image.
6. After building the Docker image, the `scripts/ci.sh` script creates a new Docker container using that image.
7. The new Docker container executes the test runner.
8. The test runner finishes running the tests and results are delivered to us via the CodeBuild UI.

### Continous Delivery

The CD (continous delivery) part is an extension of CI (Continous Integration). It's about automatically deploying all code changes after the build stage.

Software releases are automated however the team can decide the frequency of these releases (Weekly, Biweekly, etc.).

#### Usage

Avalon sets up a production [CodeBuild](https://aws.amazon.com/codebuild/) project for this purpose. The name of the CodeBuild project is `<<artifact-name>>ProductionBuild`. where `<<artifact-name>>` is the name you passed when creating the artifact when using `avalon new`.

To publish your project to npm, you only need to create and merge a pull request from the `dev` branch into your `main` branch.

#### Pre-requisites

The production [CodeBuild](https://aws.amazon.com/codebuild/) project builds need to be provided with an `NPM_AUTH_TOKEN` environmental variable to perform actions in your behalf during the `build` phase. Access tokens are an alternative to using username and passwords for authenticating in npm when using the CLI.

1. [Create an npm auth. token](https://docs.npmjs.com/about-access-tokens) (The automation token type is recommended for this).
2. [Store the the obtained auth. token in AWS Secrets manager](https://aws.amazon.com/secrets-manager/) as `AVALON_NPM_AUTH_TOKEN`.

#### How It Works

1. Changes are pushed to the GitHub repository.
2. The development CodeBuild project will trigger a new build. It makes use of the `buildspec.cd.yml` file.
3. The `install` phase executes some commands needed to use Docker without problems.
4. The `build` phase executes the `scripts/release.sh` script (passing the `NPM_AUTH_TOKEN`) which builds a Docker image using the `docker/release.Dockerfile` Dockerfile.
5. When building the Docker image, the project is copied and built inside the Docker image.
6. After building the Docker image, the `scripts/release.sh` script creates a new Docker container using that image.
7. The new Docker container executes the instructions needed to publish the artifact to the npm registry.
8. The new Docker container finishes publishing the artifact and returns some results to us via the CodeBuild UI.

## Read More

- [Avalon](https://github.com/Platekun/Avalon).
- [Docker for Development: Service Containers vs Executable Containers](https://levelup.gitconnected.com/docker-for-development-service-containers-vs-executable-containers-9fb831775133).
- [Integrating npm with external services](https://docs.npmjs.com/integrations/integrating-npm-with-external-services).
- [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html).
- [CodeBuild](https://aws.amazon.com/codebuild/).
- [Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks).
