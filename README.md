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

Before using Avalon we have to make sure we have installed the following software on your machine:

- [🐳 Docker](https://docs.docker.com/get-docker/).
- [🌳 Git](https://git-scm.com/downloads).
- [🐙 GitHub CLI](https://cli.github.com).
- [☁️ AWS CLI](https://aws.amazon.com/cli/).
- [🔬 jq](https://stedolan.github.io/jq/download/).

Additionally, you can use the following resources in case you need help setting everything up:

- [🌳 Git's](https://git-scm.com/downloads) [official guide](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup).
- [🐙 GitHub CLI's](https://cli.github.com) [official manual](https://cli.github.com/manual/).
- [☁️ AWS CLI's](https://aws.amazon.com/cli/) [Stephane Maarek's tutorial](https://www.youtube.com/watch?v=Rp-A84oh4G8).

## Defaults

### Branches

By default Avalon will create two [branches](https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell) by default:

- `dev`: Refers to the environment is the branch that engineers write code in.
- `main`: Refers to the environment is the branch that end users interact with.

Both branches are identical when your artifact is freshly created.

💡 **Note**: It is recommended to only push code to these branches via pull requests.

### Git Hooks

[Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) are a mean to fire off custom scripts when certain important actions occur while performing [🌳 Git](https://git-scm.com) actions. Git hooks are located in the `.git/hooks` where each file represents a different hook.

By default Avalon will create two client-side hooks:

- `pre-commit`: Will format files before `git commit`.
- `pre-push`:
  - Will prevent any `git push` action to `master`/`main`/`dev` branches.
  - Will format files before `git push`.

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

### Creating a New Library that leverages GitHub Actions for CI/CD

Use this recipe to create a [TypeScript](https://www.npmjs.com/package/typescript) library with a Continous Integration (CI) and Continous Delivery (CD) steps using [GitHub actions](https://github.com/features/actions). This is ideal for projects where you wish a more solid project foundation with GitHub.

By default, the CI step is triggered by every push and the CD step is triggered by creating new [GitHub releases](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository).

💡 **Note**: As a recommendation, releases should be created using the `main` branch.

```shell
avalon new ARTIFACT_NAME --artifact=library --ci-cd="github-actions"
```

### Creating a New Library that leverages AWS (CodeBuild) for CI/CD

Use this recipe to create a [TypeScript](https://www.npmjs.com/package/typescript) library with a Continous Integration (CI) and Continous Delivery (CD) steps using [AWS CodeBuild](https://aws.amazon.com/codebuild/). This is ideal for projects where you wish a more solid project foundation using the AWS ecosystem.

By default, the CI step is triggered by every code change in the repository and the CD step is triggered by merging a pull request from the `dev` branch to the `main` branch.

```shell
avalon new ARTIFACT_NAME --artifact=library --ci-cd="aws"
```

💡 **Note**: You will need to do a setup before making use of the CI/CD pipeline provided by AWS. You can read more about the steps needed in the README of the generated project.

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
    help          Display this help message.
    install       Install your project dependencies.
    develop       Spin up a development environment.
    test          Execute the test runner.
    watch-tests   Execute the test runner and watch for changes.
    format        Format your source code.
    build         Compile your source code.
    release       Release your software to the world.
    new           Create a new Avalon artifact.
    open          Browse your resources.
    destroy       Remove an avalon artifact form your machine.

Run 'avalon COMMAND help' for more information on a command.
```

### avalon install

#### Usage

```shell
avalon install
```

#### Description

Use `avalon install` to an avalon artifact form your machine. It makes use of your `package.json` and `package-lock.json`.

### avalon develop

#### Usage

```shell
avalon develop
```

#### Description

Use `avalon develop` to boot up a development environment. It will compile your code using [🧙‍♂️ TypeScript](https://www.npmjs.com/package/typescript) and listen for changes in your source files.

#### Commands

| Options | Description               |
| :------ | :------------------------ |
| `help`  | Displays the help message |

### avalon test

#### Usage

```shell
avalon test [FILE_PATH] [JEST_OPTIONS]
```

#### Description

Use `avalon test` to execute the [🃏 Jest](https://jestjs.io) test runner.

**Note**: 💡 You can use a custom test file path as well.

#### Commands

| Options | Description                  |
| :------ | :--------------------------- |
| `help`  | Displays Jest's help message |

### avalon watch-tests

#### Usage

```shell
avalon watch-tests [JEST_OPTIONS]
```

#### Description

Use `avalon watch-tests` to execute the [🃏 Jest](https://jestjs.io) test runner. The process will keep running and wait for new changes in your source code.

#### Commands

| Options | Description             |
| :------ | :---------------------- |
| `help`  | Displays Jest's message |

### avalon format

#### Usage

```shell
avalon format
```

#### Description

Use `avalon format` to format your source code using [💅 Prettier](https://prettier.io).

#### Commands

| Options | Description               |
| :------ | :------------------------ |
| `help`  | Displays the help message |

### avalon build

#### Usage

```shell
avalon build
```

#### Description

Use `avalon build` to compile your source code using the [🧙‍♂️ TypeScript compiler](https://www.npmjs.com/package/typescript).

#### Commands

| Options | Description               |
| :------ | :------------------------ |
| `help`  | Displays the help message |

### avalon release

#### Usage

```shell
avalon release
```

#### Description

Use `avalon release` to publish artifact to the npm registry.

**Note**: This command is only available for libraries built with no proper CI/CD pipeline (AKA `--ci-cd=barebones`).

#### Commands

| Options | Description               |
| :------ | :------------------------ |
| `help`  | Displays the help message |

### avalon new

#### Usage

```shell
avalon new create ARTIFACT_NAME [OPTIONS] [COMMAND]
```

#### Description

Use `avalon new` to create new software artifacts (libraries and applications).

#### Options

| Options      | Default            | Description                                                               | Valid Values                             |
| :----------- | :----------------- | :------------------------------------------------------------------------ | :--------------------------------------- |
| `--artifact` | `"library"`        | Sets the software artifact type                                           | `"library"`, `"website"`,`"application"` |
| `--ci-cd`    | `"github-actions"` | Sets the continous integration & continous delivery (CI/CD) configuration | `"barebones"`, `"github-actions", "aws`  |

#### Commands

| Options | Description               |
| :------ | :------------------------ |
| `help`  | Displays the help message |

### avalon open

#### Usage

```shell
avalon open [COMMAND]
```

#### Description

Use `avalon open` to navigate to your software artifact's resources like its repository or CI/CD pipelines.

#### Commands

| Options  | Description                                                         |
| :------- | :------------------------------------------------------------------ |
| `help`   | Displays the help message                                           |
| `repo`   | Navigate to your artifact's GitHub repository in your browser       |
| `ci`     | Navigate to your artifact's CodeBuild CI Project in your browser    |
| `cd`     | Navigate to your artifact's CodeBuild CD Project in your browser    |
| `bucket` | Navigate to your artifact's S3 Bucket in your browser               |
| `cdn`    | Navigate to your artifact's CloudFront Distribution in your browser |

### avalon destroy

#### Usage

```shell
avalon destroy ARTIFACT_NAME
```

#### Description

Use `avalon destroy` to delete an avalon artifact form your machine. It makes sure to delete all directores, docker containers, docker volumes, GitHub repositories and AWS-related infrastructure related to it.

#### Commands

| Options | Description               |
| :------ | :------------------------ |
| `help`  | Displays the help message |
