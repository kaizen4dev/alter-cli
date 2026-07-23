def "main books" [--category(-c):string --status(-s):string --minimal(-m) --search(-f)] {
  mut books = fetch books

  if ($category | is-not-empty) {
    $books = $books | where category == $category | reject category
  }

  if ($status | is-not-empty) {
    $books = $books | where status == $status | reject status
  }

  if ($minimal) {
    $books = $books | reject author picture_url id all_chapters
  }

  if ($search) {
    $books | input list -f
  } else {
    $books
  }
}

def "main create book" [
  --title(-t):string
  --category(-c):string
  --status(-s):string
  --author(-a):string
  --all_chapters(-l):float
  --read_chapters(-r):float
  --picture_url(-p):string
] {
  let params = {
    title: $title
    category: $category
    status: $status
    author: $author
    all_chapters: $all_chapters
    read_chapters: $read_chapters
    picture_url: $picture_url
  }
  post books $params
}

def "main edit book" [
  id:int
  --title(-t):string
  --category(-c):string
  --status(-s):string
  --author(-a):string
  --all_chapters(-l):float
  --read_chapters(-r):float
  --picture_url(-p):string
] {
  let params = {
    title: $title
    category: $category
    status: $status
    author: $author
    all_chapters: $all_chapters
    read_chapters: $read_chapters
    picture_url: $picture_url
  } | transpose key value | where ($it.value | is-not-empty) | transpose -rd

  patch books $id $params
}

def "main find book" [id:int] {
  fetch books $id
}

def "main delete book" [id:int] {
  delete books $id
}
