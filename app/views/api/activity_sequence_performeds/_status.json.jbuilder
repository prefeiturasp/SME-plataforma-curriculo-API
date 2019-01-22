if current_teacher
  json.performeds_status do
    json.performed activity_sequence.already_performed_by_teacher? current_teacher
    json.evaluated activity_sequence.already_evaluated_by_teacher? current_teacher
  end
end
