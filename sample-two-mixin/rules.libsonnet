{
  _config+:: {
    sampleTwoSelector: 'job="sample-two"',
  },

  prometheusRules+:: {
    groups+: [
      {
        name: 'sample-two.rules',
        rules: [
          {
            record: 'instance_path:two_requests:rate5m',
            expr: |||
              rate(two_requests_total{%(sampleTwoSelector)s}[5m])
            ||| % $._config,
          },
        ],
      },
    ],
  },
}
