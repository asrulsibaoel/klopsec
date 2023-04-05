#!/bin/bash

img='koinworks/mlflow'
tag='0.1'
docker build -t $img:$tag .

