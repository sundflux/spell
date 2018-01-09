# druidfi/spell

This is a skeleton repository which will create a new Drupal 8 project for you and setup Docker based development
environment by Amazee.io.

After the installation you'll have a directory with our template and with various tools to handle your Drupal 8
codebase.

## Requirements

- PHP and Composer
- [Docker and Cachalot/Pygmy](https://github.com/druidfi/guidelines/blob/master/docs/local_dev_env.md)

## How to use?

Create the project locally:

```
$ composer create-project druidfi/spell:dev-master <project-path> --no-interaction
```

Start the development environment and build the initial codebase:

```
$ cd <project-path>
$ composer build-dev
```

## Next steps

Git has been init in the directory `<project-path>` but you need to specify your remote before you can push.

## Other information

This project is found from the Packagist: https://packagist.org/packages/druidfi/spell
