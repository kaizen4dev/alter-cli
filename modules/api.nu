export def fetch [route:string, id?: int] {
  http get --headers (headers) ($route | link $id)
}

export def post [route: string, params: record] {
  http post --headers (headers) ($route | link) ($params | as_body)
}

export def patch [route: string, id: int, params: record] {
  http patch --headers (headers) ($route | link $id) ($params | as_body)
}

export def delete [route: string, id: int] {
  http delete --headers (headers) ($route | link $id)
}

def headers [] {
  {
    AccessToken: (load access_token)
    Content-type: application/json
  }
}

def link [id?] {
  let link = (load host) + "/api/v1/" + $in

  if ($id | is-not-empty) {
    $link + "/" + ($id | to text)
  } else {
    $link
  }
}

def as_body [] {
  $in | to json | to text
}
