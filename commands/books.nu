# Show all books
def "main books" [
  --category(-c):string # Show books only with given category
  --status(-s):string # Show books only with given status
  --minimal(-m) # Use minimal view. Excluded columns: id, author, all_chapters, picture_url
  --search(-f) # Use interactive search
] {
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

# Create new book
def "main books create" [
  --title(-t):string # A book title
  --category(-c):string # A book category. Available categories: fiction, non-fiction, manga, novels
  --status(-s):string # Status of the book. All statuses: reading, finished, dropped, planning, hiatus
  --author(-a):string # An author of the book
  --all_chapters(-l):float # A number of all chapters
  --read_chapters(-r):float # A number of chapters read by you
  --picture_url(-p):string # Url of the picture to use for the book
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

# Edit book with provided title or id
def "main books edit" [
  title_or_id # If given...
              # ... title(string) - use interactive search to find an id and then edit the book
              # ... id(number) - quietly use it to edit the book
  --title(-t):string # A new title
  --category(-c):string # New category to use
  --status(-s):string # New status to use
  --author(-a):string # New author to use
  --all_chapters(-l):float # New number of all chapters
  --read_chapters(-r):float # New number of read chapters
  --picture_url(-p):string # A url of the new picture for the book
  --minimal(-m) # Use minimal view of the books when searching for id
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

# Find the book with provided id and display it's info
def "main books find" [
  id:int # An id of the book to search for
] {
  fetch books $id
}

# Delete the book with provided id
def "main books delete" [
  id:int # An id of the book to delete
] {
  delete books $id
}
