local dEnforce = import '../../lib/dashboard-enforce.libsonnet';
local utils = import '../../lib/utils.libsonnet';
local sampleOne = import '../../mixin/sample-one-mixin/mixin.libsonnet';
local sampleTwo = import '../../mixin/sample-two-mixin/mixin.libsonnet';

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

  // override alert
  prometheusAlerts+::
    utils.overrideAlerts([
      {
        alert: 'SampleTwoUp',
        expr: |||
          up{%(sampleTwoSelector)s} == 0
        ||| % $._config,
      },
    ]),

  // override rule
  prometheusRules+::
    utils.overrideRules([
      {
        record: 'instance_path:two_requests:rate5m',
        expr: |||
          rate(two_requests_total{%(sampleTwoSelector)s}[10m])
        ||| % $._config,
      },
    ]),


  // override dashboard
  grafanaDashboards+::
    local dashboards = super.grafanaDashboards;
    local d1 = '%(sampleTwoGrafanaFolder)s/sample-two-one.json' % $._config;
    {
      [d1]:
        local out1 = std.foldl(
          function(acc, panel) acc + utils.overrideDashboardPanel(panel, acc),
          [
            {
              title: 'Requests',
              format: 'none',
            },
            {
              title: 'Requests2',
              format: 'none',
            },
          ],
          dashboards[d1],
        );
        local out2 = std.foldl(
          function(acc, elm) acc + utils.overrideDashboardPanelTarget(elm.target, elm.title, acc),
          [
            {
              title: 'Requests',
              target: {
                refId: 'A',
                expr: 'avg(instance_path:one_requests:rate5m)',
              },
            },
            {
              title: 'Requests2',
              target: {
                refId: 'A',
                expr: 'max(instance_path:one_requests:rate5m)',
              },
            },
          ],
          out1,
        );
        out2,
    },

} + dEnforce
