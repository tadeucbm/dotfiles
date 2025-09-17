#!/bin/bash

APPBUNDDLE=$1

find_window() {
  aerospace list-windows --all --format "%{app-bundle-id}"
}

find_window
