#!/bin/bash

for subdir in *; do
	if [ -f "${subdir}/generate-base.sh" ]; then
		pushd . > /dev/null
			cd "${subdir}"
			echo Processing ${subdir}...
			./generate-base.sh
		popd > /dev/null
	fi
done
