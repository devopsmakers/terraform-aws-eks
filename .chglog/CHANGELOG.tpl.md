
<a name="unreleased"></a>
## [Unreleased]
{{ if .Unreleased.CommitGroups -}}
{{ range .Unreleased.CommitGroups -}}
### {{ .Title }}
{{ range .Commits -}}
- {{ if .Scope }}**{{ .Scope }}:** {{ end }}[{{ .Hash.Short }}]({{ $.Info.RepositoryURL }}/commit/{{ .Hash.Short }}) {{ .Subject }}
{{ end -}}
{{ end }}
#### 🔮 Other Commits
{{ range .Unreleased.Commits -}}
{{ if not .Subject -}}
- {{ if .Scope }}**{{ .Scope }}:** {{ end }}[{{ .Hash.Short }}]({{ $.Info.RepositoryURL }}/commit/{{ .Hash.Short }}) {{ .Header }}
{{ end -}}
{{ end -}}
{{ end -}}
{{ range .Versions }}
<a name="{{ .Tag.Name }}"></a>
## {{ if .Tag.Previous }}[{{ .Tag.Name }}]{{ else }}{{ .Tag.Name }}{{ end }} - {{ datetime "2006-01-02" .Tag.Date }}
{{ if .CommitGroups -}}
{{ range .CommitGroups -}}
### {{ .Title }}
{{ range .Commits -}}
- {{ if .Scope }}**{{ .Scope }}:** {{ end }}[{{ .Hash.Short }}]({{ $.Info.RepositoryURL }}/commit/{{ .Hash.Short }}) {{ .Subject }}
{{ end }}
{{ end -}}
{{ end -}}
#### 🔮 Other Commits
{{ range .Commits -}}
{{ if not .Subject -}}
- {{ if .Scope }}**{{ .Scope }}:** {{ end }}[{{ .Hash.Short }}]({{ $.Info.RepositoryURL }}/commit/{{ .Hash.Short }}) {{ .Header }}
{{ end -}}
{{ end }}

{{- if .NoteGroups }}
{{ range .NoteGroups -}}
### {{ .Title }}
{{ range .Notes -}}
{{ .Body }}
{{ end }}
{{ end -}}
{{ end -}}
{{ end -}}

{{- if .Versions }}
[Unreleased]: {{ .Info.RepositoryURL }}/compare/{{ $latest := index .Versions 0 }}{{ $latest.Tag.Name }}...HEAD
{{ range .Versions -}}
{{ if .Tag.Previous -}}
[{{ .Tag.Name }}]: {{ $.Info.RepositoryURL }}/compare/{{ .Tag.Previous.Name }}...{{ .Tag.Name }}
{{ end -}}
{{ end -}}
{{ end -}}
