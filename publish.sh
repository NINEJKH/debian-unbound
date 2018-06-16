#!/usr/bin/env bash

readlink_bin="${READLINK_PATH:-readlink}"
if ! "${readlink_bin}" -f test &> /dev/null; then
  __DIR__="$(dirname "$(python -c "import os,sys; print(os.path.realpath(os.path.expanduser(sys.argv[1])))" "${0}")")"
else
  __DIR__="$(dirname "$("${readlink_bin}" -f "${0}")")"
fi

# required libs
source "${__DIR__}/.bash/functions.shlib"

set -E
trap 'throw_exception' ERR

for folder in targets/*; do
  consolelog "going into: ${folder}"
  IFS='/' read -r -a paths <<< "${folder}"

  if [[ "${paths[1]}" == "bionic" ]]; then
    consolelog "skipping ubuntu bionic for now" "error"
    continue
  fi

  for deb in "${folder}/"*.deb; do
    filename="${deb##*/}"
    name="${filename%*.deb}"
    IFS='_' read -r -a tags <<< "${name}"

    consolelog " - processing: ${filename}"

    curl \
      -X PUT \
      -T "${deb}" \
      -u "${BINTRAY_USER}:${BINTRAY_API_KEY}" \
      -f \
      "https://api.bintray.com/content/${BINTRAY_PROJECT}/${tags[0]}/${tags[1]}/${paths[1]}/${filename};deb_distribution=${paths[1]};deb_component=main;deb_architecture=${tags[2]};publish=1;override=1"
  done
done
