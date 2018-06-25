# About

An *easy* way to stage up a repository for image signing and delegation. Faciliates a demo leveraging [Docker Content Trust](https://docs.docker.com/engine/security/trust/content_trust/) as part of the [Docker Enterprise Edition Universal Control Plane (UCP)](https://docs.docker.com/ee/ucp/).

# Requirements

1. Shell script
2. Git
3. Docker Trusted Registry
4. A repository created within the Docker Trusted Registry
4. A client bundle from Docker Enterprise Edition's Universal Control Plane
5. Notary, version ```0.4.x```

# How to Use

```
$ git clone git@github.com:millerdz/image_signing_docker.git
$ cd image_signing_docker
$ # Configure the values in config.env
$ ./up.sh
```

