# GAP-and-packages integration tests

The purpose of this repository is to test various aspects of GAP and its packages.

To some degree, the tests in this repository should help us detect:
* Has GAP broken a package?
* Has a package broken GAP?
* Has one package broken itself or another package? (Somewhat).

The tests of whether GAP has broken itself currently exist in the main [gap-system/gap](https://github.com/gap-system/gap) repository.


## High-level status dashboard

This is an attempt to replicate a dashboard like the one that existed at <https://github.com/gap-system/gap-distribution/blob/master/README.md>. We hope to provide much more fine-grained status information, in the longer term.

This also serves as an easy entry to manually dispatch small subsets of these jobs.

| Test            | GAP master | GAP stable-4.11 | Manual dispatch |
|:----------------|:-----------|:--------------- |:------------------|
| GAP test suites | [![gap-master-caller](https://github.com/gap-infra/integration/actions/workflows/gap-master-caller.yml/badge.svg)](https://github.com/gap-infra/integration/actions/workflows/gap-master-caller.yml) | [![gap-stable-4.11-caller](https://github.com/gap-infra/integration/actions/workflows/gap-stable-4.11-caller.yml/badge.svg)](https://github.com/gap-infra/integration/actions/workflows/gap-stable-4.11-caller.yml) | Dispatch `gap-tests.yml` (TODO) |
| Released packages | [![pkg-master-caller](https://github.com/gap-infra/integration/actions/workflows/pkg-master-caller.yml/badge.svg)](https://github.com/gap-infra/integration/actions/workflows/pkg-master-caller.yml) |[![pkg-stable-4.11-caller](https://github.com/gap-infra/integration/actions/workflows/pkg-stable-4.11-caller.yml/badge.svg)](https://github.com/gap-infra/integration/actions/workflows/pkg-stable-4.11-caller.yml) | [Dispatch `pkg-tests.yml`](https://github.com/gap-infra/integration/actions/workflows/pkg-tests.yml) |
| Development packages | [![dev-pkg-tests-caller](https://github.com/gap-infra/integration/actions/workflows/dev-pkg-tests-caller.yml/badge.svg)](https://github.com/gap-infra/integration/actions/workflows/dev-pkg-tests-caller.yml) | – | [Dispatch `dev-pkg-tests.yml`](https://github.com/gap-infra/integration/actions/workflows/dev-pkg-tests.yml) |
