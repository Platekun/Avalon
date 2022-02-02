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
├── README.md...........................................................README of your project.
├── docker..............................................................Dockerfiles to execute commands (Use them via scripts).
│   ├── build.Dockerfile................................................Dockerfile used to execute to compile the project using TypeScript.
│   ├── ci.Dockerfile...................................................Dockerfile used for the CI step.
│   ├── format.Dockerfile...............................................Dockerfile used run prettier.
│   ├── install.Dockerfile..............................................Dockerfile used to install the node_modules of the project.
│   ├── release.Dockerfile..............................................Dockerfile used for the CD step.
│   ├── start-development.Dockerfile....................................Dockerfile used to compile to compile the project using TypeScript and watch for changes.
│   ├── test.Dockerfile.................................................Dockerfile used to execute the test runner.
│   └── watch-tests.Dockerfile..........................................Dockerfile used to execute the test runner and watch for changes.
├── library
│   ├── LICENSE.........................................................Software License.
│   ├── jest.config.js..................................................Test runner configuration.
│   ├── package.json....................................................Defines name, version and project dependencies.
│   ├── source..........................................................Actual library source code.
│   │   ├── environment.d.ts............................................Global typings.
│   │   └── index.ts....................................................Source code entrypoint.
│   ├── test............................................................Tests directory.
│   │   └── index.test.ts
│   ├── tsconfig.json...................................................TypeScript compiler configuration.
│   └── tsconfig.production.json........................................TypeScript compiler configuration for release.
├── .gitignore
├── .dockerignore.......................................................Filters out unnecesary files from your containers (Internal).
└── scripts.............................................................Bash scripts used to interact with the codebase. It uses the docker directory files udner the hood.
    ├── build.sh........................................................Script to build the project.
    ├── ci.sh...........................................................Script to build and test the project during the CI step.
    ├── format.sh.......................................................Script to format the project.
    ├── install.sh......................................................Script to install the project.
    ├── release.sh......................................................Script to release the project during the CD step.
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
./scripts/install.sh
```

### Development

Compiles your source code using the [🧙‍♂️ TypeScript compiler](https://www.npmjs.com/package/typescript) and re-compiles on changes:

```shell
./scripts/start-development.sh
```

### Tests

Starts the [🃏 Jest](https://jestjs.io) test runner:

```shell
./scripts/test.sh
```

```shell
./scripts/test.sh tests/some-test.spec.ts
```

**Note**: 💡 You can use a custom test file path.

### Watch Tests

Starts the [🃏 Jest](https://jestjs.io) test runner and watches for changes:

```shell
./scripts/watch-tests.sh
```

### Formatting

Formats your source code using [💅 Prettier](https://prettier.io)

```shell
./scripts/format.sh
```

### Building

Compiles your source code using the [🧙‍♂️ TypeScript compiler](https://www.npmjs.com/package/typescript):

```shell
./scripts/build.sh
```

**Note**: The scripts for CI (`ci.sh`) and Release(`release.sh`) are meant to be used via GitHub actions.

## CI/CD

CI/CD is a modern software development practice in which incremental changes are made frequently and then the code is delivered quickly. It is a way to provide value to customers efficientlly by using automations to shorten the release cycles.

### Continous Integration

The CI (Continous Integration) part is about integrating changes into our system in a safe way.

Source code needs to live in a centralized repository where developers will constantly push code.

A dedicated server will know when code is pushed to this repository and will check the source code by building the project and running its tests.

The build server will send the results to the responsible developer when they are ready, closing the loop of feedback.

#### Usage

To perform the CI step in your project, you only need to push code to the repository.

#### How It Works

1. A new GitHub release is created.
2. The _CI_ GitHub action (`.github/workflows/cd.yml`) is triggered.
3. The _CI_ GitHub action builds and tests the project using a `build` step.

### Continous Delivery

The CD (continous delivery) part is an extension of CI (Continous Integration). It's about automatically deploying all code changes after the build stage.

Software releases are automated however the team can decide the frequency of these releases (Weekly, Biweekly, etc.).

#### Usage

To publish your project to npm, you only need to create a new [GitHub release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository).

#### Pre-requisites

The _CD_ GitHub action needs to be provided with an `NPM_AUTH_TOKEN` to perform actions in your behalf during the `release` step. Access tokens are an alternative to using username and passwords for authenticating in npm when using the CLI.

1. [Create an npm auth. token](https://docs.npmjs.com/about-access-tokens) (The automation token type is recommended for this).
2. [Store the the obtained auth. token your GitHub repository's secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets).

#### How It Works

1. A new GitHub release is created.
2. The _CD_ GitHub action (`.github/workflows/cd.yml`) is triggered.
3. The _CD_ GitHub action builds and tests the project using a `build` step.
4. The _CD_ GitHub action moves to a `release` step where it builds and releases the project.

## Read More

- [Docker for Development: Service Containers vs Executable Containers](https://levelup.gitconnected.com/docker-for-development-service-containers-vs-executable-containers-9fb831775133).
- [Integrating npm with external services](https://docs.npmjs.com/integrations/integrating-npm-with-external-services).
- [Managing releases in a repository](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository).
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets).
