class MissingRating < StandardError
  def message
    I18n.t('activerecord.errors.messages.all_ratings_is_required')
  end
end
