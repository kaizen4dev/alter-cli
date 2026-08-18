# an alias to show fiction from books
def "main show fiction" [
  status:string="" # optionaly provide status
] {
    main books -c fiction -s $status -m
}

# an alias to show non-fiction from books
def "main show non-fiction" [
  status:string="" # optionaly provide status
] {
    main books -c non-fiction -s $status -m
}

# an alias to show manga from books
def "main show manga" [
  status:string="" # optionaly provide status
] {
    main books -c manga -s $status -m
}

# an alias to show novels from books
def "main show novels" [
  status:string="" # optionaly provide status
] {
    main books -c novels -s $status -m
}
