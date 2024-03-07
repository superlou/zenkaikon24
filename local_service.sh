#!/usr/bin/env bash

# The .env file must export secrets for local development, e.g.,
# export GUIDEBOOK_API_KEY="..."
source .env

# Force TZ, since info-beamer nodes always use UTC time.
TZ=UTC NODE=zenkaikon24 ./service