# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

## Ruby version

## System dependencies

## Configuration

## Database creation

## Database initialization

## Initialize Javascript library

```
$ yarn install --modules-folder vendor/assets/components
```

## How to run the test suite

```
$ bin/rspec
```

## Services (job queues, cache servers, search engines, etc.)

# Deployment instructions

To build and test on local environment:
```
$ docker build -t gcr.io/bluegiant-183723/bluegiant-ui .
$ docker run -t --rm -p 3000:3000 gcr.io/bluegiant-183723/bluegiant-ui
```

```
$ # List all deployments
$ kubectl get deployments
```
WTF
