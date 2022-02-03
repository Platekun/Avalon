# ⚔️ Avalon

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

Avalon is a TypeScript application/library generator with a few opinionated defaults. Use Avalon to quickly scaffold projects that leverage the benefits of using [Docker](https://www.docker.com) as a development environment.

Avalon leverages the practice of [executable containers](https://levelup.gitconnected.com/docker-for-development-service-containers-vs-executable-containers-9fb831775133) to avoid having to configure different node.js versions in your machine.

## Pre-requisites

Before using Avalon we have to make sure we have isntalled the following on your machine:

- [🐳 Docker](https://docs.docker.com/get-docker/).
- [🌳 Git](https://git-scm.com/downloads).

## Installation

It's as simple as cloning this repository and adding two things to your shell profile file (`.bashrc`, `.zshrc`, etc.):

```rc
# Needed for avalon to work
export AVALON_PATH="<<path-to-the-cloned-directory>>"

# Creates a global alias so you can execute avalon everywhere (Recommended)
alias avalon="./<<path-to-the-cloned-directory>>/run.sh"
```

After making the changes of the installation step applicable (`source ~/.bashrc`, `source ~/.zshrc`, etc.), you can now use Avalon in a new terminal window.

## Quickstart

```shell
avalon new my-cool-typescript-library
```

## Recipes

### Creating a New Barebones Library

Use this recipe to create a [TypeScript](https://www.npmjs.com/package/typescript) library without anykind of Continous Integration (CI) or Continous Delivery (CD) configuration. This is ideal for projects where you do not need the overhead of having a CI/CD steps or you wish to setup our own CI/CD steps.

```shell
avalon new ARTIFACT_NAME --artifact=library --ci-cd="barebones"
```

### Creating a New Library integrated with GitHub Actions

Use this recipe to create a [TypeScript](https://www.npmjs.com/package/typescript) library with a Continous Integration (CI) and Continous Delivery (CD) steps using [GitHub actions](https://github.com/features/actions). This is ideal for projects where you wish a more solid project foundation with GitHub.

By default, the CI step is triggered by every push and the CD step is triggered by creating new [GitHub releases](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository).

```shell
avalon new ARTIFACT_NAME --artifact=library --ci-cd="github-actions"
```

## Use the Avalon command line

### avalon

To list available commands, either run `avalon` with no parameters or execute `avalon help`:

```
$ avalon

⚔️  A TypeScript application/library generator with opinionated defaults.

🏳  Options:
    --artifact=string      Sets the software artifact type ("library"|"application").
    --ci-cd=string            Sets the continous integration configuration ("barebones"|"github-actions").

📚 Commands:
    install       Install your project dependencies.
    develop       Spin up a development environment.
    test          Execute the test runner.
    watch-tests   Execute the test runner and watch for changes.
    format        Format your source code.
    build         Compile your source code.
    release       Release your software to the world.
    new           Create a new Avalon artifact.
    help          Display this help message.

Run 'avalon COMMAND help' for more information on a command.
```

### avalon install

#### Usage

```shell
avalon install
```

#### Description

Use `avalon install` to install your software artifact dependencies. It makes use of your `package.json` and `package-lock.json`.

### avalon develop

#### Usage

```shell
avalon develop
```

#### Description

Use `avalon develop` to boot up a development environment. It will compile your code using [🧙‍♂️ TypeScript](https://www.npmjs.com/package/typescript) and listen for changes in your source files.

#### Commands

| Options | Default | Description               | Valid Values |
| :------ | :------ | :------------------------ | :----------- |
| `help`  |         | Displays the help message |              |

### avalon test

#### Usage

```shell
avalon test [FILE_PATH]  [JEST_OPTIONS]
```

#### Description

Use `avalon test` to execute the [🃏 Jest](https://jestjs.io) test runner.

**Note**: 💡 You can use a custom test file path as well.

#### Commands

| Options | Default | Description                  | Valid Values |
| :------ | :------ | :--------------------------- | :----------- |
| `help`  |         | Displays Jest's help message |              |

### avalon watch-tests

#### Usage

```shell
avalon watch-tests [JEST_OPTIONS]
```

#### Description

Use `avalon watch-tests` to execute the [🃏 Jest](https://jestjs.io) test runner. The process will keep running and wait for new changes in your source code.

#### Commands

| Options | Default | Description             | Valid Values |
| :------ | :------ | :---------------------- | :----------- |
| `help`  |         | Displays Jest's message |              |

### avalon format

#### Usage

```shell
avalon format
```

#### Description

Use `avalon format` to format your source code using [💅 Prettier](https://prettier.io).

#### Commands

| Options | Default | Description               | Valid Values |
| :------ | :------ | :------------------------ | :----------- |
| `help`  |         | Displays the help message |              |

### avalon build

#### Usage

```shell
avalon build
```

#### Description

Use `avalon build` to compile your source code using the [🧙‍♂️ TypeScript compiler](https://www.npmjs.com/package/typescript).

#### Commands

| Options | Default | Description               | Valid Values |
| :------ | :------ | :------------------------ | :----------- |
| `help`  |         | Displays the help message |              |

### avalon release

#### Usage

```shell
avalon release
```

#### Description

Use `avalon release` to publish artifact to the npm registry.

**Note**: This command is only available for libraries with `--ci-cd=barebones`.

#### Commands

| Options | Default | Description               | Valid Values |
| :------ | :------ | :------------------------ | :----------- |
| `help`  |         | Displays the help message |              |

### avalon new

#### Usage

```shell
avalon new create ARTIFACT_NAME [OPTIONS] [COMMAND]
```

#### Description

Use `avalon new` to create new software artifacts (libraries and applications).

#### Options

| Options      | Default            | Description                                  | Valid Values                      |
| :----------- | :----------------- | :------------------------------------------- | :-------------------------------- |
| `--artifact` | `"library"`        | Sets the software artifact type              | `"library"`, `"application"`      |
| `--ci-cd`    | `"github-actions"` | Sets the continous integration configuration | `"barebones"`, `"github-actions"` |

#### Commands

| Options | Default | Description               | Valid Values |
| :------ | :------ | :------------------------ | :----------- |
| `help`  |         | Displays the help message |              |
