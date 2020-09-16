#!/bin/bash

export S3GYAZO_REGION=ap-northeast-1
export S3GYAZO_BUCKET_NAME=gyazo-medley-inc

cd /home/gyazo
source import/env

bundle exec rackup --port 80 -E production -o 0.0.0.0
