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

After making the changes of the installation step applicable, you can now use Avalon in a new terminal window.

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
    new      Create a new Avalon artfiact.
    help     Display this help message.

Run 'avalon COMMAND help' for more information on a command.
```

### avalon new

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

## Recipes

### Creating a New Barebones Library

Use this recipe to create a [🌐 TypeScript](https://www.npmjs.com/package/typescript) library without anykind of Continous Integration (CI) or Continous Delivery (CD) configuration. This is ideal for projects where you do not need the overhead of having a CI/CD steps or you wish to setup our own CI/CD steps.

```shell
avalon new ARTIFACT_NAME --artifact=library --ci-cd="barebones"
```

### Creating a New Library integrated with GitHub Actions

Use this recipe to create a [🌐 TypeScript](https://www.npmjs.com/package/typescript) library with a Continous Integration (CI) and Continous Delivery (CD) steps using [GitHub actions](https://github.com/features/actions). This is ideal for projects where you wish a more solid project foundation with GitHub.

By default, the CI step is triggered by every push and the CD step is triggered by created new [GitHub releases](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository).

```shell
avalon new ARTIFACT_NAME --artifact=library --ci-cd="github-actions"
```
