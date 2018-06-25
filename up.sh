#!/bin/bash
CONFIG_ENV="config.env"
echo -e "Using environment variables from '${CONFIG_ENV}'\\n"
#shellcheck disable=SC1090
source "${CONFIG_ENV}"

mkdir -vp ${HOME}/.docker.${DTR_URL}

# initialize repository in notary
notary ${NOTARY_OPTS} init ${DTR_URL}/${NAMESPACE}/${REPO}

# publish locally staged changes
notary ${NOTARY_OPTS} publish ${DTR_URL}/${NAMESPACE}/${REPO}
 
# rotate snapshot key and change it to server managed
notary ${NOTARY_OPTS} key rotate ${DTR_URL}/${NAMESPACE}/${REPO} snapshot --server-managed
 
# create delegation for 'targets/releases' role
notary ${NOTARY_OPTS} delegation add -p ${DTR_URL}/${NAMESPACE}/${REPO} targets/releases --all-paths ${CERT_HOME}/cert.pem
 
# create delegation for 'targets/${ROLE}' role
notary ${NOTARY_OPTS} delegation add -p ${DTR_URL}/${NAMESPACE}/${REPO} targets/${ROLE} --all-paths ${CERT_HOME}/cert.pem
 
# show delegations
notary ${NOTARY_OPTS} delegation list ${DTR_URL}/${NAMESPACE}/${REPO}
 
# load the key on the client
notary ${NOTARY_OPTS} key import ${CERT_HOME}/key.pem

# test image to sign and push
docker image pull ${IMAGE_TO_SIGN}:${IMAGE_TO_SIGN_VERSION}

# enable DCT
export DOCKER_CONTENT_TRUST=1

# tag the image
docker image tag ${IMAGE_TO_SIGN}:${IMAGE_TO_SIGN_VERSION} ${DTR_URL}/${NAMESPACE}/${REPO}:${SIGNED_TAG_NAME}

# docker login
docker --config ${HOME}/.docker.${DTR_URL} login -u ${USER_NAME} ${DTR_URL}

# push image
docker --config ${HOME}/.docker.${DTR_URL} push ${DTR_URL}/${NAMESPACE}/${REPO}:${SIGNED_TAG_NAME}