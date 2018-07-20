module DestroyValidator
  def check_associations(associations)
    associations.each do |association|
      instance = send(association)
      next unless instance.present?
      klass = nil
      message = 'activerecord.errors.messages.restrict_dependent_destroy.'
      if instance.try(:last)
        klass = instance.try(:last).try(:class)
        message += 'has_many'
      else
        klass = instance.class
        message += 'has_one'
      end
      errors.add(association, I18n.t(message, record: klass.model_name.human))
      throw(:abort)
    end
  end
end
