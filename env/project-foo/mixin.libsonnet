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
  // TODO: override alert
  // TODO: override rule
  // TODO: override dashboard
}
