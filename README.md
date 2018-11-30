# Slack in docker container

Tested in Linux only (Debian Buster). Based on [jessfraz/dockerfiles](https://github.com/jessfraz/dockerfiles).

Run `bash run.sh` to build and start slack inside docker container.
`run.sh` should be executed from a regular user not root.

To update slack version export `SLACK_VERSION=<version>` variable before `run.sh`.

## Known issues

1. Links are not opened in system browser.
1. System theme is not picked.
