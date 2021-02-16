#!/bin/bash

docker run \
  -v $PWD/graphs:/var/otp/graphs \
  -e JAVA_OPTIONS=-Xmx20G \
  aelissa/otp --build /var/otp/graphs/east-midlands
  
  docker run \
  -v $PWD/graphs:/var/otp/graphs \
  -e JAVA_OPTIONS=-Xmx20G \
  aelissa/otp --build /var/otp/graphs/south-west
  
  docker run \
  -v $PWD/graphs:/var/otp/graphs \
  -e JAVA_OPTIONS=-Xmx20G \
  aelissa/otp --build /var/otp/graphs/west-midlands
  
  docker run \
  -v $PWD/graphs:/var/otp/graphs \
  -e JAVA_OPTIONS=-Xmx20G \
  aelissa/otp --build /var/otp/graphs/yorkshire
  
  
