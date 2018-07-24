module DestroyValidator
  def check_associations(associations)
    associations.each do |association|
      instance = send(association)
      next unless instance.present?
      errors.add(association, message_for(instance))
      throw(:abort)
    end
  end

  private

  def message_for(instance)
    klass = nil
    message = 'activerecord.errors.messages.restrict_dependent_destroy.'
    if instance.try(:last)
      klass = instance.try(:last).try(:class)
      message += 'has_many'
    else
      klass = instance.class
      message += 'has_one'
    end
    I18n.t(message, record: klass.model_name.human)
  end
end
