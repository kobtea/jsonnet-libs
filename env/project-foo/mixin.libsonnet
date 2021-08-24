local sampleOne = import '../../sample-one-mixin/mixin.libsonnet';
local sampleTwo = import '../../sample-two-mixin/mixin.libsonnet';

sampleOne {
  _config+:: {
    SampleOneSelector: 'job="sample-one-mod"',
    SampleOneGrafanaFolder: 'sample-one-mod',
  },
} +
sampleTwo {
  _config+:: {
    SampleTwoSelector: 'job="sample-two-mod"',
    SampleTwoGrafanaFolder: 'sample-two-mod',
  },
  // TODO: override alert
  // TODO: override rule
  // TODO: override dashboard
}
