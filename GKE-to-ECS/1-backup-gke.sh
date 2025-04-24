#!/bin/bash

kubectl get all --all-namespaces -o yaml > gke-backup.yaml
