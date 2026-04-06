#!/bin/bash

disable_app() {
  adb shell pm disable-user --user 0 "$1"
}

remove_app() {
  adb shell pm uninstall --user 0 "$1"
}

is_installed() {
  adb shell pm list packages | grep -q "$1"
}

set_dns() {
  adb shell settings put global private_dns_mode hostname
  adb shell settings put global private_dns_specifier "$1"
}

remove_dns() {
  adb shell settings put global private_dns_mode off
}