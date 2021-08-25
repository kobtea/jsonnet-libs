{
  _config+:: {
    sampleTwoSelector: 'job="sample-two"',
  },

  prometheusAlerts+:: {
    groups+: [
      {
        name: 'sample-two',
        rules: [
          {
            alert: 'SampleTwoUp',
            expr: |||
              up{%(sampleTwoSelector)s} != 1
            ||| % $._config,
            'for': '1m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Sample two is not up.',
            },
          },
          {
            alert: 'SampleTwoUp2',
            expr: |||
              up{%(sampleTwoSelector)s} != 1
            ||| % $._config,
            'for': '1m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Sample two is not up.',
            },
          },
        ],
      },
    ],
  },
}
