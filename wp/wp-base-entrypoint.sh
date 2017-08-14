#!/bin/bash
set -e

# Run the initialization process
. init

# Run the apache server
. apache2-foreground