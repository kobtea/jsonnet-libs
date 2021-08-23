{
  _config+:: {
    SampleTwoSelector: 'job="sample-two"',
  },

  prometheusRules+:: {
    groups+: [
      {
        name: 'sample-two.rules',
        rules: [
          {
            record: 'instance_path:two_requests:rate5m',
            expr: |||
              rate(two_requests_total{%(SampleTwoSelector)s}[5m])
            ||| % $._config,
          },
        ],
      },
    ],
  },
}
