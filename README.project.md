# Druid Drupal 8 project template

## About the site

- Public root in is `public` folder
- Configuration is in `conf` folder
- Custom modules are in `public/modules/custom` folder
- Custom themes are in `public/themes/custom` folder

### Contrib modules included

These recommended modules are included in the `composer.json`, but you can remove them if not needed.

- [Admin Toolbar](https://www.drupal.org/project/admin_toolbar) - Improved Drupal Toolbar
- [GDPR](https://www.drupal.org/project/gdpr) - GPDR checklist and data sanitizers
- [Pathauto](https://www.drupal.org/project/pathauto) - Automated URL alias generating
- [Swift Mailer](https://www.drupal.org/project/swiftmailer) - Advanced mailer
- [System Status](https://www.drupal.org/project/system_status) - Lumturio monitoring

## Setup a new local environment

By default we'll use Docker based environment.

### Requirements

- PHP and Composer
- [Docker and Cachalot/Pygmy](https://github.com/druidfi/guidelines/blob/master/docs/local_dev_env.md)

### Create and start the environment

Change the hostname in `docker-compose.yml` file:

E.g. `mysite.fi.docker.amazee.io` to `yoursite.fi.docker.amazee.io`

For the first time (new project member):

```
$ composer build-init
```

Then create and start the environment:

```
$ composer build-dev
```

### Login to Drupal container

This will log you inside the Drupal Docker container and in the `public` folder:

```
$ docker-compose exec --user drupal drupal bash
```

Move to project root:

```
$ cd ..
```

### Build codebase

This will download Drupal core, contrib modules and setup configuration. See Composer section below.

```
$ composer build-dev
```

### Install a new site

Install the site using the standard profile:

```
$ bin/drush -r public si standard
```

Enable additional modules:

```
$ bin/drush -r public en admin_toolbar pathauto swiftmailer system_status -y
```

CHANGE ME! Replace this with sync instructions when you have environments where to sync from.

## Build tools

### Composer

This template uses [Composer](https://getcomposer.org) to build the codebase.

Installations rely on composer.lock file. This can be updated by running `composer build-dev` which will update the
lock file. Lock file us used by testing/staging/production builds and will not be updated then.

Build codebase with dev requirements and update composer.lock file:

```
$ composer build-dev
```

Build codebase without dev requirements using composer.lock file and optimized autoloader:

```
$ composer build-production|build-testing|build-staging
```

### npm

We use npm's [`shrinkwrap`](https://docs.npmjs.com/cli/shrinkwrap) command to lock the list of installed packages. This 
ensures the exact same package versions being installed across different environments. 

See [package.json](package.json) and [npm-shrinkwrap.json](npm-shrinkwrap.json).

## Quality Assurance

### Tests

Run all tests and checks

```
$ composer test
```

Run unit tests (PHPUnit)

```
$ composer test-unit
```

Run static PHP checks

```
$ composer test-static-php
```

Run static JS checks

```
$ composer test-static-js
```

Run behavioral tests (Behat)

```
$ composer test-behavioral
```

#### PHPUnit

Drupal uses [PHPUnit](https://phpunit.de) for unit, integration, and behavioral tests. See the
[documentation](Drupal\FunctionalJavascriptTests) for more information about Drupal's usage of PHPUnit.

This template supports all PHPUnit-based tests, with the exception of `functional-javascript` tests (built on
`\Drupal\FunctionalJavascriptTests\JavaScriptTestBase`). Submodules are unsupported, because their tests cannot be
detected automatically.

#### Behat

[Behat](http://behat.org/) is used for behavioral testing. Its
configuration and the 
[features](http://docs.behat.org/en/latest/user_guide/features_scenarios.html)
to test are located in `./behat`.

### Automated builds

[Travis CI](http://travis-ci.com/) is used to run all automated analyses and tests for pull requests (PRs) and pushes.
Sensitive data **MUST** be [encrypted](https://docs.travis-ci.com/user/encrypting-files/). To instruct Travis CI to act on
changes to a particular repository, go to the *Integration & services* section of its settings page on Github, and
follow the instructions when adding *Travis CI* integration. Also update `env.global` in `./.travis.yml` with
project-specific values.
