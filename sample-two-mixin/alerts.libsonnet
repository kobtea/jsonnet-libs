{
  _config+:: {
    SampleTwoSelector: 'job="sample-two"',
  },

  prometheusAlerts+:: {
    groups+: [
      {
        name: 'sample-two',
        rules: [
          {
            alert: 'SampleTwoUp',
            expr: |||
              up{%(SampleTwoSelector)s} != 1
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
