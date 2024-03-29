#!/bin/bash
#
# 2023/08/23 Gabriel Moreau (CNRS / LEGI)

# Webhook for SWMB
# Simple Example

echo "# SWMB Webhook for host ${SWMB_HOSTNAME} under status: ${SWMB_STATUS}"
echo "# Date: $(date)"
echo "#"
echo "# HOSTNAME: ${SWMB_HOSTNAME}"
echo "# HOSTID: ${SWMB_HOSTID}"
echo "# OSVERSION: ${SWMB_OSVERSION}"
echo "# VERSION: ${SWMB_VERSION}"
echo "# USERNAME: ${SWMB_USERNAME}"
echo "# ISADMIN: ${SWMB_ISADMIN}"
echo "# STATUS: ${SWMB_STATUS}"

if [ "${SWMB_STATUS}" = 'logon' ]
then
  echo ''
  echo '# current user logon tweaks'
  echo 'DisableAutoplay_CU'

  if [ "${SWMB_HOSTNAME:0:3}" = 'abc' ]
  then
  echo ''
  echo '# tweaks for computer beginning by abc'
    echo 'HideTaskView_CU'
  fi
fi
