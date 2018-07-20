module DestroyValidator
  def check_associations(associations)
    associations.each do |association|
      _association = send(association)
      if _association.present?
        klass = nil
        message = 'activerecord.errors.messages.restrict_dependent_destroy.'
        if _association.try(:last)
          klass = _association.try(:last).try(:class)
          message += 'has_many'
        else
          klass = _association.class
          message += 'has_one'
        end
        errors.add(association, I18n.t(message, record: klass.model_name.human))
        throw(:abort)
      end
    end
  end
end
