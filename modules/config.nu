export def load [key?] {
  if ($key | is-not-empty) { config | get $key } else { config }
}

export def set [key value] {
  config | merge {$key: $value} | save (config -p) -f
}

def config [--path(-p)] {
  let folder = "~/.local/share/alter-cli" | path expand
  let config = $folder | path join "config.nuon"

  if not ($config | path exists) {
    mkdir $folder
    { access_token: "", host: "" } | save $config
  }

  if $path { $config } else { open $config }
}
