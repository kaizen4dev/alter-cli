# Show all links, optionally use interactive search
def "main links" [
  --search(-f) # Use interactive search
] {
  if ($search) {
    fetch 'links' | input list -f
  } else {
    fetch 'links'
  }
}

# Find link by id and display it's info
def "main links find" [
  id: int # An id of the link to search for
] {
  fetch 'links' $id
}

# Create new link with provided url and tags
def "main links create" [
  url # A url of the link
  ...tags # A list of tags separated with spaces
] {
  post 'links' {url: $url, tags: ($tags | str join ' ')}
}

# Edit link with provided id
def "main links edit" [
  id: int # An id of the link to edit
  ...tags # List of the tags. If tag isn't present in the link then it will be added, if tag is already present it will be removed instead.
  --url(-u)="" # Optionally provide new url
] {
  patch 'links' $id {url: $url, tags: ($tags | str join ' ')}
}

# Edit link with provided id
def "main links delete" [
  id: int # An id of the link to delete
] {
  delete 'links' $id
}
