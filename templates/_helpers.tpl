{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "esk.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "esk.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "esk.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "injector.fullname" -}}
{{- printf "%s-injector" (include "esk.fullname" .) }}
{{- end }}


{{- define "operator.fullname" -}}
{{- printf "%s-operator" (include "esk.fullname" .) }}
{{- end }}

{{- define "certificateGenerator.fullname" -}}
{{- printf "%s-certificate-generator" (include "esk.fullname" .) }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "esk.labels" -}}
helm.sh/chart: {{ include "esk.chart" . }}
{{ include "esk.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common selector labels
*/}}
{{- define "esk.selectorLabels" -}}
app.kubernetes.io/name: {{ include "esk.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Injector labels
*/}}
{{- define "injector.labels" -}}
{{- include "esk.labels" . }}
component.esk.io: injector
{{- end }}


{{/*
operator labels
*/}}
{{- define "operator.labels" -}}
{{- include "esk.labels" . }}
component.esk.io: operator
{{- end }}

{{/*
Certificate generator labels
*/}}
{{- define "certificateGenerator.labels" -}}
{{- include "esk.labels" . }}
component.esk.io: cert-gen
{{- end }}

{{/*
Injector selector labels
*/}}
{{- define "injector.selectorLabels" -}}
{{- include "esk.selectorLabels" . }}
component.esk.io: injector
{{- end }}


{{/*
operator selector labels
*/}}
{{- define "operator.selectorLabels" -}}
{{- include "esk.selectorLabels" . }}
component.esk.io: operator
{{- end }}

{{/*
Create the name of the injector service account to use
*/}}
{{- define "injector.serviceAccountName" -}}
{{- if .Values.injector.serviceAccount.create }}
{{- default (printf "%s-injector" (include "esk.fullname" .)) .Values.injector.serviceAccount.name }}
{{- else }}
{{- default (printf "%s-injector" (include "esk.fullname" .)) .Values.injector.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the operator service account to use
*/}}
{{- define "operator.serviceAccountName" -}}
{{- if .Values.operator.serviceAccount.create }}
{{- default (printf "%s-operator" (include "esk.fullname" .)) .Values.operator.serviceAccount.name }}
{{- else }}
{{- default (printf "%s-operator" (include "esk.fullname" .)) .Values.operator.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the cert-gen service account to use
*/}}
{{- define "certificateGenerator.serviceAccountName" -}}
{{- if .Values.certificateGenerator.serviceAccount.create }}
{{- default (printf "%s-cert-gen" (include "esk.fullname" .)) .Values.certificateGenerator.serviceAccount.name }}
{{- else }}
{{- default (printf "%s-cert-gen" (include "esk.fullname" .)) .Values.certificateGenerator.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "esk.backends" -}}
{{- $backends := "" }}
{{- range $backend, $values := .Values.backends }}
{{- if $values.enabled  }}
{{- $backends = printf "%s,%s" $backends $backend }}
{{- end }}
{{- end }}
{{- printf $backends | trimPrefix "," }}
{{- end -}}

{{- define "injector.certificatePath" -}}
{{- if or .Values.injector.tls.secretName .Values.certificateGenerator.enabled -}}
{{- printf "/tlsconfig/tls.crt" }}
{{- else -}}
{{- printf "%s" .Values.injector.tls.certPath -}}
{{- end -}}
{{- end -}}

{{- define "injector.keyPath" -}}
{{- if or .Values.injector.tls.secretName .Values.certificateGenerator.enabled -}}
{{- printf "/tlsconfig/tls.key" }}
{{- else -}}
{{- printf "%s" .Values.injector.tls.keyPath -}}
{{- end -}}
{{- end -}}
