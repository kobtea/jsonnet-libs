local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;

{
  _config+:: {
    sampleTwoSelector: 'job="sample-two"',
    sampleTwoGrafanaFolder: 'sample-two',
  },

  grafanaDashboards+:: {
    ['%(sampleTwoGrafanaFolder)s/sample-two-two.json' % $._config]:
      dashboard.new(
        'sample two two',
        uid='sample-two-two',
        time_from='now-1h',
      ).addTemplate(
        {
          current: {
            text: 'Prometheus',
            value: 'Prometheus',
          },
          hide: 0,
          label: null,
          name: 'datasource',
          options: [],
          query: 'prometheus',
          refresh: 1,
          regex: '',
          type: 'datasource',
        },
      )
      .addRow(
        row.new()
        .addPanel(
          graphPanel.new(
            'Requests',
            datasource='$datasource',
            span=6,
            format='short',
          )
          .addTarget(prometheus.target(
            'instance_path:two_requests:rate5m',
          ))
        )
      ),
  },
}
