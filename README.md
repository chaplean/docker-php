Docker PHP image
=====================

From `php:7.X-apache` image

## Build image

```
docker build -t chaplean/php ./7.2
```

## Push image (Public Cloud)

You need to make `docker login` first

```
docker tag chaplean/php chaplean/php:VERSION
docker push chaplean/php
```

## XDebug

XDebug is installed but not loaded to avoid performances issues. When running a php command that needs xdebug you can prepend `php -d zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20170718/xdebug.so` to load the extension.
