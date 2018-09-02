#!bin/bash

# Generates a set of 65 random chars see: man urandom

export SECRET=$(LC_ALL=C </dev/urandom tr -dc A-Za-z0-9 | head -c 65)
