# dataiku-setup

Terraform configuration files to setup Dataiku's Data Science Studio.

## Pre-requisites

### Terraform State Bucket

You need to create a bucket with the same name as declared
in the `[backend.tf](backend.tf)` file.

A suggested naming convention for this is `${var.project_id}-tfstate`.

## Setting up SSL

### Nginx Config

CentOS 7 comes with Nginx out of the box. You need to edit `nginx.conf`
file located in `/etc/nginx/nginx.conf` to something similar
to the `[nginx.conf](nginx.conf)` file in this repo.
