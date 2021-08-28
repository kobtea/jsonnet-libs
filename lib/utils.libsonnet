local gu = import 'github.com/grafana/jsonnet-libs/mixin-utils/utils.libsonnet';
local ku = import 'github.com/kubernetes-monitoring/kubernetes-mixin/lib/utils.libsonnet';

{
  // Common
  arrayHas(arr, value)::
    std.length(std.find(value, arr)) != 0,

  matchString(patterns, str)::
    $.arrayHas([
      if pat == '__ALL__'
      then true
      else std.length(std.findSubstr(pat, str)) != 0
      for pat in patterns
    ], true),

  // Alert
  mapAlert(f)::
    ku.mapRuleGroups(f),

  removeAlert(name)::
    gu.removeAlertRuleGroup(name),

  replaceAlert(rule)::
    local f(baseRule) =
      if baseRule.alert == rule.alert
      then rule
      else baseRule;
    $.mapAlert(f),

  overrideAlert(rule)::
    local f(baseRule) =
      if baseRule.alert == rule.alert
      then baseRule + rule
      else baseRule;
    $.mapAlert(f),

  overrideAlerts(rules)::
    local f(acc, rule) = acc + $.overrideAlert(rule);
    std.foldl(f, rules, {}),

  // Rule
  mapRule(f)::
    ku.mapRuleGroups(f),

  removeRule(name)::
    gu.removeRecordingRuleGroup(name),

  replaceRule(rule)::
    local f(baseRule) =
      if baseRule.record == rule.record
      then rule
      else baseRule;
    $.mapRule(f),

  overrideRule(rule)::
    local f(baseRule) =
      if baseRule.record == rule.record
      then baseRule + rule
      else baseRule;
    $.mapRule(f),

  overrideRules(rules)::
    local f(acc, rule) = acc + $.overrideRule(rule);
    std.foldl(f, rules, {}),

  // Dashboard
  mapDashboards(f, filenamePatterns, dashboards):: {
    [filename]:
      if $.matchString(filenamePatterns, filename)
      then f(dashboards[filename])
      else dashboards[filename]
    for filename in std.objectFieldsAll(dashboards)
  },

  // Dashboard - Panel
  mapDashboardPanel(f, dashboard)::
    dashboard {
      rows: [
        row {
          panels: [
            f(panel)
            for panel in row.panels
          ],
        }
        for row in dashboard.rows
      ],
    },

  removeDashboardPanel(title, dashboard)::
    local f(panel) =
      if panel.title == title
      then null
      else panel;
    $.mapDashboardPanel(f, dashboard),

  replaceDashboardPanel(panel, dashboard)::
    local f(basePanel) =
      if basePanel.title == panel.title
      then panel
      else basePanel;
    $.mapDashboardPanel(f, dashboard),

  overrideDashboardPanel(panel, dashboard)::
    local f(basePanel) =
      if basePanel.title == panel.title
      then basePanel + panel
      else basePanel;
    $.mapDashboardPanel(f, dashboard),

  overrideDashboardPanels(panels, dashboard)::
    local f(acc, panel) = acc + $.overrideDashboardPanel(panel, dashboard);
    std.foldl(f, panels, {}),

  // Dashboard - Panel - Target
  overrideDashboardPanelTarget(target, panelTitle, dashboard)::
    local f(basePanel) =
      if basePanel.title == panelTitle
      then
        basePanel {
          targets: [
            if baseTarget.refId == target.refId
            then baseTarget + target
            else baseTarget
            for baseTarget in basePanel.targets
          ],
        }
      else basePanel;
    $.mapDashboardPanel(f, dashboard),

  overrideDashboardPanelTargets(targets, panelTitle, dashboard)::
    local f(acc, target) = acc + $.overrideDashboardPanelTarget(target, panelTitle, dashboard);
    std.foldl(f, targets, {}),

}
