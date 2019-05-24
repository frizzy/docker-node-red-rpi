#!/bin/bash
set -e

if [ -z "${PUID}" ]
then
	PUID=node-red
	GUID=node-red
fi

exec gosu ${PUID}:${PGID} "$@" 
