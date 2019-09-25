# Laravel Vapor Action

[![Latest Version](https://img.shields.io/github/release/ubient/laravel-vapor-action.svg?style=flat-square)](https://github.com/ubient/laravel-vapor-action/releases)

This package provides a way to use Laravel Vapor directly from Github Actions.

## Requirements

This Github Action has a few requirements. First and foremost, you will need to have Github Actions enabled for the account you're planning to use this action on.
If you are not yet part of the beta, you can [sign up here](https://github.com/features/actions/signup/).

Furthermore, you will need an active [Laravel Vapor](https://vapor.laravel.com) subscription.

## Usage

### Setting up a Github Secret
In order to authenticate with Vapor from Github Actions, we will need to add a `VAPOR_API_TOKEN` [secret](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables).
To do so, you may do the following:
1. On GitHub, navigate to the main page of the repository you intend to use this action on.
2. Under your repository name, click `Settings`.
3. In the left sidebar, click `Secrets`.
4. Click `Add a new secret`.
5. For the name of your secret, enter `VAPOR_API_TOKEN`.
6. For the value itself, enter your Laravel Vapor API token. You may generate one in your  [Vapor API settings dashboard](https://vapor.laravel.com/app/account/api-tokens).
7. Click `Add secret`.

### Setting up our Github Action
Next, let's head over to the `Actions` page, and create a new workflow.
To keep things simple, let's set up an action that deploys to production as soon as a branch is merged into master:

```yaml
name: Deploy to production
on:
  push:
    branches:
      - master

jobs:
  vapor:
    name: Deploy to production
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - uses: ubient/laravel-vapor-action@master
      env:
        VAPOR_API_TOKEN: ${{ secrets.VAPOR_API_TOKEN }}
      with:
        args: "deploy production"
```

> **Note**: To find out more regarding this syntax, you can take a look at [this page](https://help.github.com/en/articles/workflow-syntax-for-github-actions#onevent_nametypes).

#### Explanation

The above does a few things:
1. It does a git checkout out your Laravel App (your repository) using the `actions/checkout` action.
2. It builds the `ubient/laravel-vapor-action@master` image (using this repository's Dockerfile).
3. It runs the built container, passing in the Vapor API token previously configured in your repository's Github Secrets.
4. It executes the `vapor` CLI command, passing in the arguments given. In our example, this means it runs `vapor deploy production`.

## Changelog

Please see [CHANGELOG](CHANGELOG.md) for more information what has changed recently.

## Contributing

Please see [CONTRIBUTING](CONTRIBUTING.md) for details.

## Security

If you discover any security related issues, please email claudio@ubient.net instead of using the issue tracker.

## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
