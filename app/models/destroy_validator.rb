module DestroyValidator
  def check_associations(associations)
    associations.each do |association|
      a = send(association)
      if a.present?
        klass = nil
        message = 'activerecord.errors.messages.restrict_dependent_destroy.'
        if a.try(:last)
          klass = a.try(:last).try(:class)
          message += 'has_many'
        else
          klass = a.class
          message += 'has_one'
        end
        errors.add(association, I18n.t(message, record: klass.model_name.human))
        throw(:abort)
      end
    end
  end
end
