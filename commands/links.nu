def "main links" [--search(-s)] {
  if ($search) {
    fetch 'links' | input list -f
  } else {
    fetch 'links'
  }
}

def "main find link" [id: int] {
  fetch 'links' $id
}

def "main create link" [url ...tags] {
  post 'links' {url: $url, tags: ($tags | str join ' ')}
}

def "main edit link" [id: int ...tags --url(-u)=""] {
  patch 'links' $id {url: $url, tags: ($tags | str join ' ')}
}

def "main delete link" [id: int] {
  delete 'links' $id
}
