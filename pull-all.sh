#!/bin/bash
git pull origin
git submodule foreach 'git pull origin || :'
