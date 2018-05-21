ixc-acme.sh
===

Improvements to [acme.sh](https://github.com/Neilpang/acme.sh):

- Add the ability to exec commands on other Docker services (e.g. reload HAproxy) after renewing certificates.

- Add a web server on port 80 to handle HTTP-01 challenges, and redirect HTTP requests to HTTPS.


Installation
---

Deploy the included `docker-compose.yml` file to your Docker swarm.


Usage
---

Certificates are initially issued via one-time `exec` commands on the `acme` service. Then they are deployed via another one-time `exec` command. They are renewed automatically.

For domains hosted with DNS Made Easy:

    --issue -d 'example.com' -d '*.example.com' --dns dns_me --dnssleep 15

For domains hosted elsewhere, with an `_acme-challenge` CNAME pointing at `_acme-challenge.ixchosted.com`:

    --issue -d 'example.com' -d '*.example.com' --challenge-alias ixchosted.com --dns dns_me --dnssleep 15

For domains hosted elsewhere, with an `_acme-challenge` CNAME pointing at `acme-challenge.ixchosted.com` (because they don't allow hostnames with a leading underscore):

    --issue -d 'example.com' -d '*.example.com' --domain-alias acme-challenge.ixchosted.com --dns dns_me --dnssleep 15

For domains that cannot use DNS-01 challenge:

    --issue -d 'example.com' -d 'foo.example.com' -w /www

To deploy and restart HAproxy:

    --deploy -d 'example.com' --deploy-hook haproxy

**NOTE:** All of the above commands should be executed via Portainer's `Use custom command` option, or via `docker exec`. If you want to execute these commands from an interactive shell, prefix them with `acme.sh`.


Assumptions
---

- [DNS Made Easy](https://dnsmadeeasy.com/) is used for DNS-01 challenges. If not, update the `ME_*` environment variables and `--dns dns_me` command line argument, per https://github.com/Neilpang/acme.sh/blob/master/dnsapi/README.md

- [dockercloud-haproxy](https://github.com/docker/dockercloud-haproxy) is used for SSL termination, via `system_haproxy` service and `system_haproxy-data` volume (see [ixc/dockercloud-stacks](https://github.com/ixc/dockercloud-stacks/blob/master/portainer/system.yml)). If not, update `volumes`, `DEPLOY_HAPROXY_*` environment variables, and `--deploy-hook haproxy` command line argument, per https://github.com/Neilpang/acme.sh/blob/master/deploy/README.md

- Deployed to Docker for AWS, with persistent shared CloudStor volumes. If not, update `volumes` in `docker-compose.yml`.
