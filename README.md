# jsonnet-libs

This repository aims to manage [Monitoring Mixins](https://monitoring.mixins.dev) and libraries for Jsonnet.
Monitoring mixin is a set of Prometheus rules and Grafana dashboards.

## Overview

## As a project template

To use this repository as a project template, fork and clone it.
See usage section below.

## As a library and mixin

To use libraries and mixins in this repository, install packages you need with jsonnet-bundler.

```bash
$ cd your-project
$ jb init
$ jb install https://github.com/kobtea/jsonnet-libs/lib@main
$ jb install https://github.com/kobtea/jsonnet-libs/mixin/sample-one-mixin@main
```

## Directory structure

```bash
# dist contains generated rules and dashboards.
# Deploy these files to each environment.
├── dist
│   ├── project-foo
│   │   ├── alerts.yml
│   │   ├── dashboards
│   │   └── rules.yml
│   └── project-k8s
│       └── ...
# env contains config for each environment.
# environment is a logical unit such a `prod`, `dev`, `service1-in-eks` or `service2-in-gke`.
# mixin.libsonnet is the entry point of mixin for each environment.
├── env
│   ├── project-foo
│   │   ├── mixin.libsonnet
│   └── project-k8s
│       └── ...
# lib contains jsonnet libraries not mixin.
├── lib
│   └── utils.libsonnet
# mixin contains monitoring mixins.
└── mixin
    ├── sample-one-mixin
    │   ├── alerts.libsonnet
    │   ├── config.libsonnet
    │   ├── dashboards
    │   │   ├── dashboards.libsonnet
    │   │   ├── sample-one-one.libsonnet
    │   │   └── sample-one-two.libsonnet
    │   ├── jsonnetfile.json
    │   ├── jsonnetfile.lock.json
    │   ├── mixin.libsonnet
    │   └── rules.libsonnet
    └── sample-two-mixin
        └── ...
```

## Requirements

- [jsonnet](https://github.com/google/jsonnet) or [go-jsonnet](https://github.com/google/go-jsonnet)
- [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler)
- [promtool](https://github.com/prometheus/prometheus)
- [mixtool](https://github.com/monitoring-mixins/mixtool)
- [fswatch](https://github.com/emcrisostomo/fswatch)

## Usage

Setup this repository.

```bash
$ git clone https://github.com/kobtea/jsonnet-libs.git
$ cd jsonnet-libs
$ jb install
```

### Prepare minxins

#### Use mixins at another repository

If you want to use mixin at another repository such a [kubernetes-mixin](https://github.com/kubernetes-monitoring/kubernetes-mixin), install that package with jsonnet-bundler.

```bash
$ jb install https://github.com/kubernetes-monitoring/kubernetes-mixin
```

#### Create mixins at this repository

If you want to create a new mixin at this repository, refer to sample mixins at [here](https://github.com/kobtea/jsonnet-libs/tree/main/mixin).

### Create environments

Create a config file for a new environment.
The only need is a file name of entry point is `mixin.libsonnet`.

```bash
$ mkdir env/project-sample
$ vim env/project-sample/mixin.libsonnet
```

Include mixins and override values.

```jsonnet
$ cat env/project-sample/mixin.libsonnet
local sampleOne = import '../../mixin/sample-one-mixin/mixin.libsonnet';
local k8s = import 'kubernetes-mixin/mixin.libsonnet';

sampleOne {
  _config+:: {
    sampleOneSelector: 'job="sample-one-mod"',
  },
} +
k8s {
  _config+:: {
    nodeExporterSelector: 'job="node"',
  },
}
```

Useful functions are under lib directory.
Full example is [here](https://github.com/kobtea/jsonnet-libs/blob/main/env/project-foo/mixin.libsonnet).

```jsonnet
// include utils
local utils = import '../../lib/utils.libsonnet';

// override alert
utils.overrideAlerts([
  {
    alert: 'SampleTwoUp',
    expr: |||
      up{%(sampleTwoSelector)s} == 0
    ||| % $._config,
  },
]),

// override rule
utils.overrideRules([
  {
    record: 'instance_path:two_requests:rate5m',
    expr: |||
      rate(two_requests_total{%(sampleTwoSelector)s}[10m])
    ||| % $._config,
  },
]),

// override dashboard
local dashboards = super.grafanaDashboards;
local d1 = '%(sampleTwoGrafanaFolder)s/sample-two-one.json' % $._config;
{
  [d1]:
    std.foldl(
      function(acc, elm) acc + utils.overrideDashboardPanelTarget(elm.target, elm.title, acc),
      [
        {
          title: 'Requests',
          target: {
            refId: 'A',
            expr: 'avg(instance_path:one_requests:rate5m)',
          },
        },
        {
          title: 'Requests2',
          target: {
            refId: 'A',
            expr: 'max(instance_path:one_requests:rate5m)',
          },
        },
      ],
      dashboards[d1],
    )
},
```

### Generate rules and dashboards

```bash
# format and check syntax
$ make fmt
$ make lint

# generate yaml and json
$ make generate ARG=project-sample
```

Output files are in dist directory.

### Deploy

Deployment is out of the scope of this project.