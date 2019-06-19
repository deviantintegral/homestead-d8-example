#!/bin/bash -ex

[ -f results.csv ] || cp results.header.csv results.csv

for provider in providers/*
do
  echo $provider
  echo $provider | sed 's/^providers\///' > provider
  for config in $provider/*
  do
    cp $config Homestead.yaml.example
    rm Homestead.yaml
    vendor/bin/homestead make
    echo "${config##*.}" > sync-type
    vagrant up
    vagrant destroy -f
    rm sync-type
  done
  rm provider
done
