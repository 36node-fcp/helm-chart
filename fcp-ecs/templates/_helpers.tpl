{{/*
Expand the name of the chart.
*/}}
{{- define "fcp-ecs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fcp-ecs.fullname" -}}
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
{{- define "fcp-ecs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "fcp-ecs.labels" -}}
helm.sh/chart: {{ include "fcp-ecs.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "fcp-ecs.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "admin-web.selectorLabels" -}}
{{- include "fcp-ecs.selectorLabels" . }}
app.kubernetes.io/name: {{ .Values.adminWeb.name }}
{{- end }}

{{- define "roadmap.selectorLabels" -}}
{{- include "fcp-ecs.selectorLabels" . }}
app.kubernetes.io/name: {{ .Values.roadmap.name }}
{{- end }}

{{- define "api.selectorLabels" -}}
{{- include "fcp-ecs.selectorLabels" . }}
app.kubernetes.io/name: {{ .Values.api.name }}
{{- end }}

{{- define "auth.selectorLabels" -}}
{{- include "fcp-ecs.selectorLabels" . }}
app.kubernetes.io/name: {{ .Values.auth.name }}
{{- end }}

{{- define "robot-dahua.selectorLabels" -}}
{{- include "fcp-ecs.selectorLabels" . }}
app.kubernetes.io/name: {{ .Values.robotDahua.name }}
{{- end }}

{{- define "robot-dahua-mock.selectorLabels" -}}
{{- include "fcp-ecs.selectorLabels" . }}
app.kubernetes.io/name: {{ .Values.robotDahua.mock.name }}
{{- end }}

{{- define "robot-hengtong.selectorLabels" -}}
{{- include "fcp-ecs.selectorLabels" . }}
app.kubernetes.io/name: {{ .Values.robotHengtong.name }}
{{- end }}

{{- define "robot-xindian.selectorLabels" -}}
{{- include "fcp-ecs.selectorLabels" . }}
app.kubernetes.io/name: {{ .Values.robotXindian.name }}
{{- end }}

{{- define "robot-xindian2.selectorLabels" -}}
{{- include "fcp-ecs.selectorLabels" . }}
app.kubernetes.io/name: {{ .Values.robotXindian2.name }}
{{- end }}

{{- define "robot-mock.selectorLabels" -}}
{{- include "fcp-ecs.selectorLabels" . }}
app.kubernetes.io/name: {{ .Values.robotMock.name }}
{{- end }}