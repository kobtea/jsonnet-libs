{
  _config+:: {
    sampleOneSelector: 'job="sample-one"',
  },

  prometheusAlerts+:: {
    groups+: [
      {
        name: 'sample-one',
        rules: [
          {
            alert: 'SampleOneUp',
            expr: |||
              up{%(sampleOneSelector)s} != 1
            ||| % $._config,
            'for': '1m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Sample one is not up.',
            },
          },
        ],
      },
    ],
  },
}
