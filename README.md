# druidfi/spell

This is a composer create-project repository which will create Druid's Drupal 8 project on top of our template `druidfi/drupal-project`.

After the installation you'll have a directory with our template which is setup with git hooks and various tools to handle your Drupal 8 codebase.

## Requirements

- PHP and Composer
- Read access to druifi/drupal-project repository

## How to use?

```
$ composer create-project druidfi/spell:dev-master <project-path> --stability dev --no-interaction
```

## Next steps

Git has been init in the directory `<project-path>` but you need to specify your remote before you can push.

More documentation on the template can be found at the [druidfi/drupal-project](https://github.com/druidfi/drupal-project) repository.

## Other information

This project is found from the Packagist: https://packagist.org/packages/druidfi/spell
