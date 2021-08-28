local utils = import '../../lib/utils.libsonnet';
local k = import 'kubernetes-mixin/mixin.libsonnet';

k {
  _config+:: {
    nodeExporterSelector: 'job="node"',
  },
  prometheusAlerts+::
    utils.overrideAlerts([
      {
        alert: 'KubePodCrashLooping',
        'for': '30m',
      },
      {
        alert: 'KubePodNotReady',
        labels: {
          severity: 'critical',
        },
      },
    ]),
}
