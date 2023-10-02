# Tune GitHub-hosted runner network

This action aims to provide an OS-neutral interface to disable TCP/UDP offload
to fix flaky networking on GitHub-hosted runners.

### Motivation

[actions/runner-images#1187](https://github.com/actions/runner-images/issues/1187)

### Roadmap

Once `@actions/runner-images-team` resolves the upstream issue, we will mark the
action as deprecated. As it is impossible to eliminate the action from
everyone's workflow even if we mark the action as deprecated, and since it is
unsure whether we can continue to provide full support after that, we aim not to
add any runtime dependencies. So we do not merge pull requests that migrate to
the
[JavaScript action](https://docs.github.com/en/actions/creating-actions/about-custom-actions).

### Usage

We adhere to [semantic versioning](https://semver.org), it's safe to use the
major version (`v1`) in your workflow.

```yml
runs-on: ubuntu-latest

steps:
  - name: Tune GitHub-hosted runner network
    uses: smorimoto/tune-github-hosted-runner-network@v1

  - name: Checkout tree
    uses: actions/checkout@v4
```
