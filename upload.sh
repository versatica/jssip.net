#!/bin/bash

set -e


nanoc compile
nanoc deploy --target production
