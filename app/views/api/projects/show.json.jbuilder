json.teacher_name @teachers
json.slug @project.slug
json.development_year @project.development_year
json.development_class @project.development_class
json.id @project.id
json.cover_image url_for(@project.cover_image) if @project.cover_image.attached?
json.owners @project.owners
json.title @project.title.titleize
json.summary @project.summary
json.description @project.description
json.curricular_components @project.curricular_components
json.segments @project.segments
json.stages @project.stages
json.years @project.years
json.knowledge_matrices @project.knowledge_matrices
json.learning_objectives @project.learning_objectives
json.student_protagonisms @project.student_protagonisms
json.axes @project.axes
json.school @project.school.present? ? @project.school.name : @project.school_name
json.regional_education_board @project.regional_education_board.present? ? @project.regional_education_board.name : @project.dre
json.already_saved_in_collection @project.already_saved_in_collection? current_user.teacher if (current_user.present? && current_user.teacher.present?)
json.sustainable_development_goals @project.sustainable_development_goals do |sds|
  json.name sds.name
  json.icon_url variant_url(sds.icon, :icon)
  json.sub_icon_url url_for(sds.sub_icon)
end
json.comments @project.comments do |c|
  json.id c.id
  json.teacher_id c.teacher_id
  json.teacher_name c.teacher.user.name
  json.body c.body
end
json.links @project.project_links
