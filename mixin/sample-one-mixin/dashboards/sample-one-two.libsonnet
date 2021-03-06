local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;

{
  _config+:: {
    sampleOneSelector: 'job="sample-one"',
    sampleOneGrafanaFolder: 'sample-one',
  },

  grafanaDashboards+:: {
    ['%(sampleOneGrafanaFolder)s/sample-one-two.json' % $._config]:
      dashboard.new(
        'sample one two',
        uid='sample-one-two',
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
            'instance_path:one_requests:rate5m',
          ))
        )
      ),
  },
}
