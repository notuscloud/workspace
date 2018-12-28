# workspace

This is a tooling container. It comes with a few tools like:

* Hashicorp `vault`
* Hashicorp `consul`
* Hashicorp `terraform`
* Ansible

## How it works

The container's entrypoint starts a tmux session in `detached` mode, then starts
a single `sleep` loop.

## Usage

* Run this container in backgroup

```bash
docker run -d --name workspace notuscloud/workspace-docker 
```

* Connect to the container

```bash
docker exec -ti workspace zsh
```

* Attach to the tmux session

```bash
tmux attach-session
```
