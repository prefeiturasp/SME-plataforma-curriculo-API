json.array! @answer_books do |answer_book|
  json.id answer_book.id
  json.name answer_book.name
  json.year answer_book.year
  json.level answer_book.level
  json.curricular_component answer_book.curricular_component.name
  json.cover_image "/assets/#{answer_book.cover_image_identifier}"
  json.book_file "/assets/#{answer_book.book_file_identifier}"
end
