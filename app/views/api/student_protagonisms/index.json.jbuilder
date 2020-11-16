json.array! @student_protagonisms do |student_protagonism|
  json.id student_protagonism.id
  json.title student_protagonism.title
  json.description student_protagonism.description
  json.sequence student_protagonism.sequence
end
