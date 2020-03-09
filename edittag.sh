#!/bin/bash
sed "s/tag/$1/g" pods.yml > nginx-app-pod.yml
