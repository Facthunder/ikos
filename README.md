# Docker image for ikos

This project aims to provide a simple Docker image to encapsulate and run an [ikos](https://github.com/NASA-SW-VnV/ikos) analysis through Docker.

### Run ikos

#### Run all checks
Assuming current directory contains the source code to analyze, simply run the following command:
```Dockerfile
docker run --rm -v ${PWD}:/src facthunder/ikos:latest ikos file.c > report.txt
```

### Versions matrix
Here is the versions matrix of the image:

|                          TAG                           |                       IKOS VERSION                       |                        BASE IMAGE                      |
|:------------------------------------------------------:|:------------------------------------------------------------:|:------------------------------------------------------:|
|   [latest](https://hub.docker.com/r/facthunder/ikos)   | [3.0](https://github.com/NASA-SW-VnV/ikos/releases/tag/v3.0) | [ubuntu:19.04](https://hub.docker.com/_/ubuntu) |
|    [3.0](https://hub.docker.com/r/facthunder/ikos)     | [3.0](https://github.com/NASA-SW-VnV/ikos/releases/tag/v3.0) | [ubuntu:19.04](https://hub.docker.com/_/ubuntu) |
|    [2.2](https://hub.docker.com/r/facthunder/ikos)     | [2.2](https://github.com/NASA-SW-VnV/ikos/releases/tag/v2.2) | [ubuntu:19.04](https://hub.docker.com/_/ubuntu) |


### How to contribute
If you experienced a problem with the plugin please open an issue. Inside this issue please explain us how to reproduce this issue and paste the log.

If you want to do a PR, please put inside of it the reason of this pull request. If this pull request fix an issue please insert the number of the issue or explain inside of the PR how to reproduce this issue.

### License
Copyright 2020 Facthunder.

Licensed under the [GNU General Public License, Version 3.0](https://www.gnu.org/licenses/gpl.txt)
