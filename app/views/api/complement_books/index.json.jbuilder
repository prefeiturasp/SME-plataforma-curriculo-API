json.array! @complement_books do |complement_book|
  json.id complement_book.id
  json.name complement_book.name
  json.author complement_book.author
  json.partner complement_book.partner
  json.cover_image "/assets/#{complement_book.cover_image_identifier}"
  json.book_file book_file_api_complement_book_path(complement_book.id)
  json.complement_book_links complement_book.complement_book_links
end
