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
  title_or_id
  --title(-t):string
  --category(-c):string
  --status(-s):string
  --author(-a):string
  --all_chapters(-l):float
  --read_chapters(-r):float
  --picture_url(-p):string
  --minimal(-m)
] {
  let id = match ($title_or_id | describe) {
    "int" => $title_or_id
    "string" => {
      mut books = fetch books

      if ($minimal) {
        $books = $books | reject all_chapters picture_url author
      }

      $books | 
        where ($it.title | str contains -i $title_or_id) |
        input list | get id
    }
    _ => { error make -u "Provided invalid title or id" }
  }

  let params = {
    title: $title
    category: $category
    status: $status
    author: $author
    all_chapters: $all_chapters
    read_chapters: $read_chapters
    picture_url: $picture_url
  } | transpose key value | where ($it.value | is-not-empty) | transpose -rd

  if ($params | is-empty) {
    print "You didn't specify anything to edit."
    return
  }

  let edited_columns = $params | columns
  let old_book = fetch books $id
  let new_book = patch books $id $params

  $edited_columns | each {|column|
    print $" - Changed ($column) from ($old_book | get $column) to ($new_book | get $column)"
  }

  return $new_book
}

def "main find book" [id:int] {
  fetch books $id
}

def "main delete book" [id:int] {
  delete books $id
}
