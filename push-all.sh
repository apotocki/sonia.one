#!/bin/bash
git push origin
git submodule foreach 'git push origin || :'
