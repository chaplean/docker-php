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
docker tag chaplean/php chaplean/php:latest
docker push chaplean/php
```
