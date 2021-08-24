{
  _config+:: {
    sampleOneSelector: 'job="sample-one"',
  },

  prometheusRules+:: {
    groups+: [
      {
        name: 'sample-one.rules',
        rules: [
          {
            record: 'instance_path:one_requests:rate5m',
            expr: |||
              rate(one_requests_total{%(sampleOneSelector)s}[5m])
            ||| % $._config,
          },
        ],
      },
    ],
  },
}
