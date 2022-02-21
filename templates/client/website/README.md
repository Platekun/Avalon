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
├── .editorconfig.......................................................Defines a consistent indentation style.
├── .gitignore..........................................................Filters out unnecesary files from your Git commits.
├── README.md...........................................................README of your project.
├── aws.................................................................AWS related files.
│   ├── buildspec.cd.yml................................................Development CodeBuild project configuration file (CD Step).
│   └── ci-cd.template.json.............................................CloudFormation template used to provide the infrastructure of this artifact.
├── docker..............................................................Dockerfiles to execute commands (Use them via scripts).
│   ├── build.Dockerfile................................................Dockerfile used to execute to compile the project using TypeScript.
│   ├── release.Dockerfile..............................................Dockerfile used to execute to release to npm.
│   ├── format.Dockerfile...............................................Dockerfile used run prettier.
│   ├── install.Dockerfile..............................................Dockerfile used to install the node_modules of the project.
│   └── start-development.Dockerfile....................................Dockerfile used to compile to compile the project using TypeScript and watch for changes.
├── scripts
│   ├── build.sh........................................................Script to build the project.
│   ├── format.sh.......................................................Script to format the project.
│   ├── install.sh......................................................Script to install the project.
│   ├── release.sh......................................................Script to release the project.
│   └── start-development.sh............................................Script to start development.
└── ui
    ├── .posthtmlrc.....................................................Configuration file for Parcel PostHTML.
    ├── .prettierignore.................................................Filters out files that won't be formatted.
    ├── .prettierrc.json................................................File formatter.
    ├── package.json....................................................Defines name, version and project dependencies.
    └── source..........................................................Actual library source code.
        ├── assets......................................................Static assets of your website.
        │   ├── fonts...................................................Website fonts.
        │   ├── images..................................................Website images.
        │   │   ├── android-chrome-192x192.png
        │   │   ├── android-chrome-512x512.png
        │   │   ├── apple-touch-icon.png
        │   │   ├── favicon-32x32.png
        │   │   ├── favicon.ico
        │   │   └── swords.svg
        │   ├── includes................................................Website parcel includes (https://parceljs.org/languages/html/).
        │   │   ├── google-analytics.html
        │   │   ├── page-meta.html
        │   │   ├── page-scripts.html
        │   │   ├── page-stylesheets.html
        │   │   └── website-info.html
        │   ├── scripts.................................................Website scripts.
        │   │   ├── pages...............................................Website specific page scripts.
        │   │   │   ├── error.page.ts
        │   │   │   └── index.page.ts
        │   │   └── vendor..............................................Third-party scripts.
        │   ├── stylesheets.............................................Website stylesheets.
        │   │   ├── pages...............................................Website specific page stylesheets.
        │   │   │   ├── error.page.css
        │   │   │   └── index.page.css
        │   │   ├── theme...............................................Website stylesheets per concern.
        │   │   │   ├── animations.css
        │   │   │   ├── button.css
        │   │   │   ├── checkbox.css
        │   │   │   ├── colors.css
        │   │   │   ├── divider.css
        │   │   │   ├── form.css
        │   │   │   ├── icons.css
        │   │   │   ├── index.css
        │   │   │   ├── layouts.css
        │   │   │   ├── list.css
        │   │   │   ├── radio.css
        │   │   │   ├── root.css
        │   │   │   ├── textfield.css
        │   │   │   ├── typography.css
        │   │   │   ├── utility.css
        │   │   │   ├── variables.css
        │   │   │   └── z-index.css
        │   │   └── vendor..............................................Third-party stylesheets.
        │   │       └── normalize.css
        │   └── videos..................................................Website videos.
        ├── error.html..................................................Default error page.
        ├── humans.txt..................................................Contains information about the people who have contributed this building the website. (https://humanstxt.org)
        ├── index.html..................................................Default home page.
        ├── robots.txt..................................................Tells search engine crawlers which URLs the crawler can access on your site.
        └── site.webmanifest............................................Provides information about the website (in case it is used as a PWA).
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

Compiles your source code using the [🧙‍♂️ Parcel Bundler](https://parceljs.org) which re-compiles on changes:

```shell
bash ./scripts/start-development.sh
```

alternatively you can run the script using the Avalon CLI:

```shell
avalon develop
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

Compiles your source code using the [🧙‍♂️ Parcel Bundler](https://parceljs.org):

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

For website artifacts, avalon **does not** creates any kind of testing or CI configuration, we believe most _web sites_ should use the least amount of js and should rely on CSS features when possible.

### Continous Delivery

The CD (continous delivery) part is an extension of CI (Continous Integration). It's about automatically deploying all code changes after the build stage.

Software releases are automated however the team can decide the frequency of these releases (Weekly, Biweekly, etc.).

#### Usage

Avalon sets up three things for this purpose:

- A [CodeBuild](https://aws.amazon.com/codebuild/) project. The name of the CodeBuild project is `<<artifact-name>>ProductionBuild`, where `<<artifact-name>>` is the name you passed when creating the artifact when using `avalon new`.
- A [S3 Bucket](https://aws.amazon.com/s3/). The name of the S3 bucket is `<<artifact-name>>-bucket`, where `<<artifact-name>>` is the name you passed when creating the artifact when using `avalon new`.
- A [CloudFront](https://aws.amazon.com/cloudfront/) distribution. The name of the CloudFront distribution is random and it depends entirely on Amazon.

To use this infrastructure you only need to to create and merge a pull request from the `dev` branch into your `main` branch.

The CodeBuild project will be responsible of uploading your project the S3 Bucket which will serve as an [origin server](https://www.cloudflare.com/learning/cdn/glossary/origin-server/) for the CloudFront distribution.

**Note** 💡: Only the CloudFront distribution will have access to the contents of the bucket.

#### How It Works

1. Changes are pushed to the GitHub repository.
2. The development CodeBuild project will trigger a new build. It makes use of the `buildspec.cd.yml` file.
3. The `install` phase executes some commands needed to use Docker without problems.
4. The `build` phase executes the `scripts/release.sh` script (passing some AWS credentials) which builds a Docker image using the `docker/release.Dockerfile` Dockerfile.
5. When building the Docker image, the project is copied and built inside the Docker image.
6. After building the Docker image, the `scripts/release.sh` script creates a new Docker container using that image.
7. The new Docker container executes the instructions needed to publish the artifact to our S3 bucket.
8. The new Docker container finishes uploading the artifact and returns some results to us via the CodeBuild UI.
9. The CodeBuild build creates a CloudFront invalidation so the next time a viewer requests the file, CloudFront returns to the origin to fetch the latest version of the file.
10. The CodeBuild build finishes.

## Read More

- [Avalon](https://github.com/Platekun/Avalon).
- [Docker for Development: Service Containers vs Executable Containers](https://levelup.gitconnected.com/docker-for-development-service-containers-vs-executable-containers-9fb831775133).
- [CodeBuild](https://aws.amazon.com/codebuild/).
- [What's a CDN](https://www.cloudflare.com/learning/cdn/what-is-a-cdn/).
- [Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks).
