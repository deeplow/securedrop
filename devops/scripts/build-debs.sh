#!/bin/bash
# shellcheck disable=SC2209
#
# Wrapper around debian build logic to bootstrap virtualenv

set -e
set -u
set -o pipefail

. ./devops/scripts/boot-strap-venv.sh

virtualenv_bootstrap

RUN_TESTS="${1:-test}"
TARGET_PLATFORM="${2:-trusty}"
SCENARIO_NAME="builder-${TARGET_PLATFORM}"

if [[ "${CIRCLE_BRANCH:-}" != docs-* ]]; then
    case "$RUN_TESTS" in
        notest)
            molecule_action=converge
            ;;
        test)
            molecule_action=test
            ;;
    esac

    molecule "${molecule_action}" -s "${SCENARIO_NAME}"
else
    echo Not running on docs branch...
fi
