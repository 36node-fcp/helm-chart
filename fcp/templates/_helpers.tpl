{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "fcp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fcp.fullname" -}}
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
{{- define "fcp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "fcp.labels" -}}
helm.sh/chart: {{ include "fcp.chart" . }}
{{ include "fcp.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "fcp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fcp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "fcp.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "fcp.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Return the proper image name
{{ include "fcp.images.image" ( dict "imageRoot" .Values.path.to.the.image "global" .Values.global ) }}
*/}}
{{- define "fcp.images.image" -}}
{{- $registryName := .imageRoot.registry -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $separator := ":" -}}
{{- $termination := .imageRoot.tag | toString -}}
{{- if .global }}
    {{- if .global.imageRegistry }}
     {{- $registryName = .global.imageRegistry -}}
    {{- end -}}
{{- end -}}
{{- if .imageRoot.digest }}
    {{- $separator = "@" -}}
    {{- $termination = .imageRoot.digest | toString -}}
{{- end -}}
{{- if $registryName }}
    {{- printf "%s/%s%s%s" $registryName $repositoryName $separator $termination -}}
{{- else -}}
    {{- printf "%s%s%s"  $repositoryName $separator $termination -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names (deprecated: use fcp.images.renderPullSecrets instead)
{{ include "fcp.images.pullSecrets" ( dict "images" (list .Values.path.to.the.image1, .Values.path.to.the.image2) "global" .Values.global) }}
*/}}
{{- define "fcp.images.pullSecrets" -}}
  {{- $pullSecrets := list }}

  {{- if .global }}
    {{- range .global.imagePullSecrets -}}
      {{- if kindIs "map" . -}}
        {{- $pullSecrets = append $pullSecrets .name -}}
      {{- else -}}
        {{- $pullSecrets = append $pullSecrets . -}}
      {{- end }}
    {{- end -}}
  {{- end -}}

  {{- range .images -}}
    {{- range .pullSecrets -}}
      {{- if kindIs "map" . -}}
        {{- $pullSecrets = append $pullSecrets .name -}}
      {{- else -}}
        {{- $pullSecrets = append $pullSecrets . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- if (not (empty $pullSecrets)) }}
imagePullSecrets:
    {{- range $pullSecrets | uniq }}
  - name: {{ . }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
Return ingress rule path item
{{- if include "fcp.ingress.path" (list .Values.some-module .Values.service) -}}
*/}}
{{- define "fcp.ingress.path" -}}
{{- $module := index . 0 -}}
{{- $service := index . 1 -}}
  path: {{ $module.path }}
  pathType: ImplementationSpecific
  backend:
    service:
      name: {{ $module.name }}
      port:
        number: {{ default $service.port $module.port }}
{{- end -}}

{{/*
Define a helper to check if any item in a list has a non-empty hostname.
{{- if include "fcp.ingress.hasHostname" $items -}}
*/}}
{{- define "fcp.ingress.hasHostname" -}}
{{- $hasHostname := false -}}
{{- range . -}}
  {{- if .hostname -}}
    {{- $hasHostname = true -}}
  {{- end -}}
{{- end -}}
{{- $hasHostname -}}
{{- end -}}

{{/*
Define a helper to check if any item in a list has an empty hostname but has path.
{{- if include "fcp.ingress.hasHostLessPath" $items -}}
*/}}
{{- define "fcp.ingress.hasHostLessPath" -}}
{{- $hasHostLessPath := false -}}
{{- range . -}}
  {{- if and (not .hostname) .path -}}
    {{- $hasHostLessPath = true -}}
  {{- end -}}
{{- end -}}
{{- $hasHostLessPath -}}
{{- end -}}

{{/*
Return full url of module endpoint
{{ include "fcp.endpoint" .Values.module }}
*/}}
{{- define "fcp.endpoint" -}}
{{- if .hostname }}
    {{- printf "//%s%s"  .hostname .path -}}
{{- else -}}
    {{- printf "%s"  .path -}}
{{- end -}}
{{- end -}}