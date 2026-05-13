#!/bin/bash

- name: Run inline bash
  run: |
    echo "Hello from Bash"
    ls -la
  shell: bash