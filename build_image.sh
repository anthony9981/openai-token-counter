#!/usr/bin/env bash
#docker buildx create --name mybuilder --bootstrap --use
docker buildx build --platform linux/amd64,linux/arm64 --push -t anthony9981/openai-token-counter:latest .
