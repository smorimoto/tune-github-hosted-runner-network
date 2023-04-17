# Tune GitHub-hosted runner network

This action aims to provide an OS-neutral interface to disable TCP/UDP offload
to fix flaky networking on GitHub-hosted runners

### Motivation

[actions/runner-images#1187](https://github.com/actions/runner-images/issues/1187)

### Roadmap

Once @actions/runner-images-team resolves the upstream issue, we will mark the
action as deprecated. As it is impossible to eliminate the action from
everyone's workflow even if we mark the action as deprecated, and we are not
sure we can provide full support once we stop using the action, we aim not to
add any runtime dependencies. So we will not merge pull requests that update to
a JavaScript action.

### Usage

```yml
runs-on: ubuntu-latest

steps:
  - name: Checkout tree
    uses: actions/checkout@v3

  - name: Tune GitHub-hosted runner network
    uses: smorimoto/tune-github-hosted-runner-network@v1
```
