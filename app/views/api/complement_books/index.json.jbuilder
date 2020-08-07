json.array! @complement_books do |complement_book|
  json.id complement_book.id
  json.name complement_book.name
  json.author complement_book.author
  json.description complement_book.description
  json.curricular_component complement_book.curricular_component.name
  json.cover_image "/assets/#{complement_book.cover_image_identifier}"
  json.book_file "/assets/#{complement_book.book_file_identifier}"
end
