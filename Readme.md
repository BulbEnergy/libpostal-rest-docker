# Libpostal REST Docker

libpostal (https://github.com/openvenues/libpostal) is a C library for
parsing and normalizing street addresses. Using libpostal requires
compiling a C program that downloads ~2GB of training data.

This Dockerfile automates that compilation and creates a container
with libpostal and [libpostal-rest](https://github.com/johnlonganecker/libpostal-rest) libpostal-rest which allows for a simple REST API
that makes it easy interact with libpostal.

## Build image and start up container

```sh
docker build -t libpostal-rest .
docker run -d -p 8080:8080 libpostal-rest
```

On M1 macbook:

```sh
docker build -t libpostal-rest --platform linux/x86_64 .
docker run -d -p 8081:8080 --platform linux/x86_64 libpostal-rest
```

See REST API [here](https://github.com/johnlonganecker/libpostal-rest) 

## Examples

```sh
curl -k -X POST -d '{"query": "100 main st buffalo ny"}' https://localhost:8081/parser
```
