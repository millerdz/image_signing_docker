#!/bin/bash
CONFIG_ENV="config.env"
echo -e "Using environment variables from '${CONFIG_ENV}'\\n"
#shellcheck disable=SC1090
source "${CONFIG_ENV}"
# remove data; local and remote (optional - WARNING! will remove all trust data remote and local)

notary ${NOTARY_OPTS} delete ${DTR_URL}/${NAMESPACE}/${REPO} --remote
curl -v -X DELETE -H "Authorization: Bearer $(curl -sk -d '{"username":"YOUR_USERNAME","password":"YOUR_PASSWORD"}' https://${UCP_URL}/auth/login | jq -r .auth_token)" https://${UCP_URL}/api/trust/${DTR_URL}/${NAMESPACE}/${REPO}

KEY_TO_REMOVE=$(notary ${NOTARY_OPTS} key list | grep delegation | awk '{print $2}')
notary ${NOTARY_OPTS} key remove ${KEY_TO_REMOVE}