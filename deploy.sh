#!/usr/bin/env bash

if [ "$CONTEXT" = "production" ]
then
	hugo -e production --baseURL "$URL" --minify
else
	hugo -e staging --baseURL "$DEPLOY_PRIME_URL" --minify
fi
