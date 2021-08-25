local gu = import 'github.com/grafana/jsonnet-libs/mixin-utils/utils.libsonnet';
local ku = import 'github.com/kubernetes-monitoring/kubernetes-mixin/lib/utils.libsonnet';

{
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
    self.mapAlert(f),

  overrideAlert(rule)::
    local f(baseRule) =
      if baseRule.alert == rule.alert
      then baseRule + rule
      else baseRule;
    self.mapAlert(f),

  overrideAlerts(rules)::
    local f(acc, rule) = acc + self.overrideAlert(rule);
    std.foldl(f, rules, {}),

  // Rule
  removeRule(name)::
    gu.removeRecordingRuleGroup(name),

  // Dashboard
}
