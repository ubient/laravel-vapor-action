# Laravel Vapor Action

[![Latest Version](https://img.shields.io/github/release/ubient/laravel-vapor-action.svg?style=flat-square)](https://github.com/ubient/laravel-vapor-action/releases)

This Github Action provides a way to directly use Laravel Vapor from within your CI pipeline.\
Need anything beyond the default extensions necessary for Laravel, or **want to optimize for build speed**? [We've got you covered](#advanced-usage).

## Requirements

To use this Github Action, you will need an active [Laravel Vapor](https://vapor.laravel.com) subscription.

## Usage

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

### 2. Setting up our Github Action
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
    - uses: actions/checkout@v1
    - uses: ubient/laravel-vapor-action@master
      env:
        VAPOR_API_TOKEN: ${{ secrets.VAPOR_API_TOKEN }}
      with:
        args: "deploy production"
```

:fire: To speed things up significantly and allow for customization, we highly recommend [using this workflow instead](#advanced-usage).

#### Explanation

The above does a few things:
1. It does a git checkout out your Laravel App (your repository) using the `actions/checkout` action.
2. It builds the `ubient/laravel-vapor-action@master` image (using this repository's Dockerfile).
3. It runs the built container, passing in the Vapor API token previously configured in your repository's Github Secrets.
4. It executes the `vapor` CLI command, passing in the arguments given. In our example, this means it runs `vapor deploy production`.

If you would like to find out more regarding the syntax used by Github Actions, you can take a look at [this page](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#onevent_nametypes).


## Advanced usage
Need something extra, such as caching, a different PHP version or additional PHP extensions? That's possible!\
[Set up a Github Secret like previously described](#1-setting-up-a-github-secret), but use the following instead when creating an Actions workflow:

```yaml
name: Deploy to Production

on:
  push:
    branches: [ master ]

jobs:
  vapor:
    name: Check out, build and deploy using Vapor
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Setup PHP (w/ extensions) & Composer
        uses: shivammathur/setup-php@v2
        with:
          php-version: 7.4
          tools: pecl
          extensions: bcmath, ctype, fileinfo, json, mbstring, openssl, pdo, tokenizer, xml
          coverage: none

      - name: Obtain Composer cache directory
        id: composer-cache
        run: echo "::set-output name=dir::$(composer config cache-files-dir)"

      - name: Cache Composer dependencies
        uses: actions/cache@v1
        with:
          path: ${{ steps.composer-cache.outputs.dir }}
          # Use composer.json for key, if composer.lock is not committed.
          # key: ${{ runner.os }}-composer-${{ hashFiles('**/composer.json') }}
          key: ${{ runner.os }}-composer-${{ hashFiles('**/composer.lock') }}
          restore-keys: ${{ runner.os }}-composer-

      - name: Install Vapor CLI Globally
        run: composer global require laravel/vapor-cli

      - name: Install Composer dependencies
        run: composer install --no-progress --no-suggest --prefer-dist --optimize-autoloader

      - name: Obtain NPM Cache directory (used by Laravel Mix)
        id: node-cache-dir
        run: echo "::set-output name=dir::$(npm config get cache)" # Use $(yarn cache dir) for yarn

      - name: Cache NPM dependencies (used by Laravel Mix)
        uses: actions/cache@v1
        with:
          path: ${{ steps.node-cache-dir.outputs.dir }}
          key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }} # Use '**/yarn.lock' for yarn
          restore-keys: ${{ runner.os }}-node-

      - name: Deploy using Laravel Vapor
        env:
          VAPOR_API_TOKEN: ${{ secrets.VAPOR_API_TOKEN }}
        run: /home/runner/.composer/vendor/bin/vapor deploy production
```

Using the above (and triggering the build twice in a row), we found our sequential builds to be more than a whole minute faster on average!
![Example of speed gains, with and without a warmed cache](/images/advanced-usage-caching.png)


## Changelog

Please see [CHANGELOG](CHANGELOG.md) for more information what has changed recently.

## Contributing

Please see [CONTRIBUTING](CONTRIBUTING.md) for details.

## Security

If you discover any security related issues, please email claudio@ubient.net instead of using the issue tracker.

## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
