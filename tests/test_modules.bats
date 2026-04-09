#!/usr/bin/env bats

@test "Check Bash syntax for all modules" {
  for module in modules/*.sh; do
    run bash -n "$module"
    [ "$status" -eq 0 ]
  done
}

@test "Check setup script syntax" {
  run bash -n setup-ghee
  [ "$status" -eq 0 ]
}

@test "Check ghee-functions syntax" {
  run bash -n ghee-functions.sh
  [ "$status" -eq 0 ]
}

@test "Ensure modules define _GG_REGISTRY" {
  for module in modules/*.sh; do
    run grep -q "_GG_REGISTRY\[" "$module"
    [ "$status" -eq 0 ]
  done
}
