# ⚔️ Avalon

Avalon is a TypeScript application/library generator with a few opinionated defaults. Use Avalon to quickly scaffold projects that leverage the benefits of using [Docker](https://www.docker.com) as a development environment.

Avalon leverages the practice of executable containers to avoid having to configure different node.js versions in your machine. Read More at [Docker for Development: Service Containers vs Executable Containers](https://levelup.gitconnected.com/docker-for-development-service-containers-vs-executable-containers-9fb831775133).

## Pre-requisites

Before using Avalon make sure you have [🐳 Docker](https://docs.docker.com/get-docker/) installed on your machine.

## Installation

It's as simple as cloning this repository and adding two things to your shell profile file (`.bashrc`, `.zshrc`, etc.):

```rc
# Needed for avalon to work
export AVALON_PATH="<<path-to-the-cloned-directory>>"

# Creates a global alias so you can execute avalon everywhere (Optional)
alias avalon="./<<path-to-the-cloned-directory>>/run.sh"
```

After making the changes of the installation step applicable, you can now use Avalon in a new terminal window.

## Usage

### Creating a New Barebones Library

A _barebones_ library is a [🌐 TypeScript](https://www.npmjs.com/package/typescript) library without anykind of Continous Integration (CI) configuration. This is ideal for projects where you do not need the overhead of having a CI step or you wish to setup our own CI step.

```shell
avalon new barebones-library <<library-name>>
```

#### Scripts

After creating our project, you will find several commands inside an `scripts` directory:

#### Installation

Installs the library dependencies (AKA your node_modules):

```shell
./scripts/install.sh
```

#### Development

Compiles your source code using the [🌐 TypeScript compiler](https://www.npmjs.com/package/typescript) and re-compiles on changes:

```shell
./scripts/start-development.sh
```

#### Tests

Starts the test runner (💡 You can use a custom test file path):

```shell
./scripts/test.sh
```

```shell
./scripts/test.sh tests/some-test.spec.ts
```

#### Watch Tests

Starts the test runner and watches for changes:

```shell
./scripts/watch-tests.sh
```

#### Formatting

Formats your source code using [🌐 Prettier](https://prettier.io)

```shell
./scripts/format.sh
```

#### Building

Compiles your source code using the [🌐 TypeScript compiler](https://www.npmjs.com/package/typescript):

```shell
./scripts/build.sh
```

#### Deploying to NPM

Prompts your [🌐 npm](https://www.npmjs.com) credentials to publish your package:

```shell
./scripts/deploy.sh
```
