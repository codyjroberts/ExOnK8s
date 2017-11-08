#!/bin/sh

pod=$(kubectl get pods --selector=app=exonk8s -o jsonpath="{.items[0].metadata.name}")
pod_cookie=$(kubectl get secret exonk8s-secrets -o json | jq '.data["POD_COOKIE"]' | sed -e 's/^"//' -e 's/"$//' | base64 --decode)
kubectl exec $pod -it -c exonk8s -- iex --name remote@127.0.0.1 --remsh exonk8s@127.0.0.1 --cookie $pod_cookie
