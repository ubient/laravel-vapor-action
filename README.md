[![Latest Version](https://img.shields.io/github/release/ubient/laravel-vapor-action.svg?style=flat-square)](https://github.com/ubient/laravel-vapor-action/releases)

# Laravel Vapor Action

This Github Action is no longer maintained, and has been removed from the Github Marketplace.

While this package will remain available/installable for the forseeable future, **this package WILL NOT be receiving any further (security) updates going forward**. Instead, you are recommended to use the significantly faster and more flexible approach as documented below:

![image](https://user-images.githubusercontent.com/1752195/121706739-33743d00-cad6-11eb-9885-95c32c472082.png)

## Replacement / recommended alternative approach

Please note that you will need an active [Laravel Vapor](https://vapor.laravel.com) subscription.

### 1. Setting up a Github Secret
In order to authenticate with Vapor from Github Actions, we will need to add a `VAPOR_API_TOKEN` [secret](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets#creating-encrypted-secrets) to your repository.\
To do so, you may do the following:
1. On GitHub, navigate to the main page of the repository you intend to use this action on.
2. Under your repository name, click `Settings`.
3. In the left sidebar, click `Secrets`.
4. Click `Add a new secret`.
5. For the name of your secret, enter `VAPOR_API_TOKEN`.
6. For the value itself, enter your Laravel Vapor API token. You may generate one in your  [Vapor API settings dashboard](https://vapor.laravel.com/app/account/api-tokens).
7. Click `Add secret`.
![Example of the Project Settings Secrets page](/images/project-settings-secrets.png)

### 2. Setting up your Github Action

Next, let's head over to the `Actions` page, and create a new workflow.\
To keep things simple, let's set up an action that deploys to production as soon as a branch is merged into master:

```yaml
name: Deploy to production

on:
  push:
    branches: [ master ]

jobs:
  vapor:
    name: Check out, build and deploy using Vapor
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Setup PHP
      uses: shivammathur/setup-php@v2
      with:
        php-version: 8.0
        tools: composer:v2
        coverage: none
    - name: Require Vapor CLI
      run: composer global require laravel/vapor-cli
    - name: Deploy Environment
      run: vapor deploy
      env:
        VAPOR_API_TOKEN: ${{ secrets.VAPOR_API_TOKEN }}
```

#### Explanation

The above does a few things:
1. It does a git checkout out your Laravel App (your repository) using the `actions/checkout` action.
2. It prepares your PHP environment using the amazing [shivammathur/setup-php](https://github.com/shivammathur/setup-php).
3. It installs the [Laravel Vapor CLI](https://docs.vapor.build/1.0/introduction.html#installing-the-vapor-cli) using Composer.
5. It executes the `vapor` CLI command using [the `deploy` argument](https://docs.vapor.build/1.0/projects/deployments.html#initiating-deployments).

If you would like to find out more regarding the syntax used by Github Actions, you can take a look at [this page](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#onevent_nametypes).
