# Getting Started with Avalon

This project was bootstrapped with Avalon.

## Project Structure

```
root
├── README.md...........................................................README of your project.
├── docker..............................................................Dockerfiles to execute commands (Use them via scripts).
│   ├── build.Dockerfile................................................Dockerfile used to execute to compile the project using TypeScript.
│   ├── deploy.Dockerfile...............................................Dockerfile used to execute to deploy to npm.
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
│   └── tsconfig.production.json........................................TypeScript compiler configuration for deployment.
├── .gitignore
├── .dockerignore.......................................................Filters out unnecesary files from your containers (Internal).
└── scripts.............................................................Bash scripts used to interact with the codebase. It uses the docker directory files udner the hood.
    ├── build.sh........................................................Script to build the project.
    ├── deploy.sh.......................................................Script to deploy the project.
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
./scripts/install.sh
```

### Development

Compiles your source code using the [🌐 TypeScript compiler](https://www.npmjs.com/package/typescript) and re-compiles on changes:

```shell
./scripts/start-development.sh
```

### Tests

Starts the test runner (💡 You can use a custom test file path):

```shell
./scripts/test.sh
```

```shell
./scripts/test.sh tests/some-test.spec.ts
```

### Watch Tests

Starts the test runner and watches for changes:

```shell
./scripts/watch-tests.sh
```

### Formatting

Formats your source code using [🌐 Prettier](https://prettier.io)

```shell
./scripts/format.sh
```

### Building

Compiles your source code using the [🌐 TypeScript compiler](https://www.npmjs.com/package/typescript):

```shell
./scripts/build.sh
```

### Deploying to NPM

Prompts your [🌐 npm](https://www.npmjs.com) credentials to publish your package:

```shell
./scripts/deploy.sh
```

## Read More

- [Docker for Development: Service Containers vs Executable Containers](https://levelup.gitconnected.com/docker-for-development-service-containers-vs-executable-containers-9fb831775133)
