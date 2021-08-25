JSONNET_FMT := jsonnetfmt -n 2 --max-blank-lines 2 --string-style s --comment-style s
fmt:
	@find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
	ARG=project-fooxargs -n 1 -- $(JSONNET_FMT) -i

generate-alerts:
	@test ${ARG} \
	&& ( \
		mkdir -p dist/${ARG}; \
		jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "./env/${ARG}/mixin.libsonnet").prometheusAlerts)' > ./dist/${ARG}/alerts.yml \
	) \
	|| echo 'need entrypoint like: make generate-alerts ARG=project-foo'

generate-rules:
	@test ${ARG} \
	&& ( \
		mkdir -p dist/${ARG}; \
		jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "./env/${ARG}/mixin.libsonnet").prometheusRules)' > ./dist/${ARG}/rules.yml \
	) \
	|| echo 'need entrypoint like: make generate-rules ARG=project-foo'

generate-dashboards:
	@test ${ARG} \
	&& ( \
		mkdir -p dist/${ARG}; \
		jsonnet -J vendor -m ./dist/${ARG}/dashboards -c -e '(import "./env/${ARG}/mixin.libsonnet").grafanaDashboards' \
	) \
	|| echo 'need entrypoint like: make generate-dashboards ARG=project-foo'

generate: generate-alerts generate-rules generate-dashboards
