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
│   ├── release.Dockerfile..............................................Dockerfile used to execute to release to npm.
│   ├── format.Dockerfile...............................................Dockerfile used run prettier.
│   ├── install.Dockerfile..............................................Dockerfile used to install the node_modules of the project.
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
│   └── tsconfig.production.json........................................TypeScript compiler configuration for releasement.
├── .avaloncli.json.....................................................Avalon CLI configuration file. Contains metadata about the artifact (Internal).
├── .gitignore..........................................................Filters out unnecesary files from your Git commits.
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

### Publishing to NPM

Prompts your [📦 npm](https://www.npmjs.com) credentials to publish your package:

```shell
bash ./scripts/release.sh
```

alternatively you can run the script using the Avalon CLI:

```shell
avalon release
```

## Git Hooks

Git hooks are a mean to fire off custom scripts when certain important actions occur while performing [🌳 Git](https://git-scm.com) actions. Git hooks are located in the `.git/hooks` where each file represents a different hook.

Avalon sets up two client-side hooks:

- `pre-commit`: Will format files before `git commit`.
- `pre-push`:
  - Will prevent any `git push` action to `master`/`main`/`dev` branches.
  - Will format files before `git push`.

## Read More

- [Avalon](https://github.com/Platekun/Avalon).
- [Docker for Development: Service Containers vs Executable Containers](https://levelup.gitconnected.com/docker-for-development-service-containers-vs-executable-containers-9fb831775133).
- [Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks).
