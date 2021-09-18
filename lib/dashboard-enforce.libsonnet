{
  local dashboards = super.grafanaDashboards,

  grafanaDashboards:: {
    [filename]: dashboards[filename] {
      uid: std.md5(filename),
    }
    for filename in std.objectFieldsAll(dashboards)
  },
}
