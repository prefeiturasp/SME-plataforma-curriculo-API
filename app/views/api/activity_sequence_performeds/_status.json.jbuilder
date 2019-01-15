if current_teacher
  json.performeds_status do
    json.performed activity_sequence.already_performed_by_teacher? current_teacher
    json.evaluated activity_sequence.already_evaluated_by_teacher? current_teacher
    json.number_of_not_evaluated current_teacher.activity_sequence_performeds.evaluateds.count
  end
end
