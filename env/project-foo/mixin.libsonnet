local utils = import '../../lib/utils.libsonnet';
local sampleOne = import '../../sample-one-mixin/mixin.libsonnet';
local sampleTwo = import '../../sample-two-mixin/mixin.libsonnet';

sampleOne {
  _config+:: {
    sampleOneSelector: 'job="sample-one-mod"',
    sampleOneGrafanaFolder: 'sample-one-mod',
  },
} +
sampleTwo {
  _config+:: {
    sampleTwoSelector: 'job="sample-two-mod"',
    sampleTwoGrafanaFolder: 'sample-two-mod',
  },

  // override alert
  prometheusAlerts+::
    utils.overrideAlerts([
      {
        alert: 'SampleTwoUp',
        expr: |||
          up{%(sampleTwoSelector)s} == 0
        ||| % $._config,
      },
    ]),

  // TODO: override rule
  // TODO: override dashboard
}
