Docker PHP image
=====================

From `php:7.1-apache` image

## Build image

```
docker build -t chaplean/php .
```

## Push image (Public Cloud)

You need to make `docker login` first

```
docker tag chaplean/php chaplean/php:VERSION
docker push chaplean/php
```

## XDebug

XDebug is installed but not loaded to avoid performances issues. When running a php command that needs xdebug you can prepend `php -d zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so` to load the extension.
