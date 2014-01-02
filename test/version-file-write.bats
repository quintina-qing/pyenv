#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$PYENV_TEST_DIR"
  cd "$PYENV_TEST_DIR"
}

@test "invocation without 2 arguments prints usage" {
  run pyenv-version-file-write
  assert_failure "Usage: pyenv version-file-write <file> <version>"
  run pyenv-version-file-write "one" ""
  assert_failure
}

@test "setting nonexistent version fails" {
  assert [ ! -e ".python-version" ]
  run pyenv-version-file-write ".python-version" "1.8.7"
  assert_failure "pyenv: version \`1.8.7' not installed"
  assert [ ! -e ".python-version" ]
}

@test "writes value to arbitrary file" {
  mkdir -p "${PYENV_ROOT}/versions/1.8.7"
  assert [ ! -e "my-version" ]
  run pyenv-version-file-write "${PWD}/my-version" "1.8.7"
  assert_success ""
  assert [ "$(cat my-version)" = "1.8.7" ]
}
