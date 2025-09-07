{{/*
Generate full name with chart and release name
*/}}
{{- define "3tier.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Namespace helper
*/}}
{{- define "3tier.namespace" -}}
{{ .Values.namespace }}
{{- end }}
