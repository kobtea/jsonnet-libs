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
}
