json.array! @answer_books do |answer_book|
  json.id answer_book.id
  json.name answer_book.name
  json.cover_image url_for(answer_book.cover_image)
  json.book_file url_for(answer_book.book_file)
  json.curricular_component_id answer_book.curricular_component_id
end
