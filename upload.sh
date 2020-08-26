#!/bin/bash

set -e


nanoc co
nanoc deploy --target production
