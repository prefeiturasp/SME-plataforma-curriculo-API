module Admin
  module BaseHelper
    def human_attribute_years
      LearningObjective.years.map { |k, _v| [I18n.t("activerecord.attributes.enums.years.#{k}"), k] }
    end

    def human_attribute_roadmap_statuses
      Roadmap.statuses.map { |k, _v| [I18n.t("activerecord.attributes.roadmap.statuses.#{k}"), k] }
    end

    def sequence_options(_model)
      options = _model.order(:sequence).pluck(:sequence)
      options << (options[-1].nil? ? [1] : (options[-1] + 1))
    end

    def toolbar_options # rubocop:disable Metrics/MethodLength
      [%w[bold italic underline strike],
       ['blockquote'],
       [{ 'header': 1 }, { 'header': 2 }],
       [{ 'list': 'ordered' }, { 'list': 'bullet' }],
       [{ 'script': 'sub' }, { 'script': 'super' }],
       [{ 'indent': '-1' }, { 'indent': '+1' }],
       [{ 'direction': 'rtl' }],
       [{ 'size': ['small', false, 'large', 'huge'] }],
       [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
       ['image'],
       ['divider'],
       ['clean']]
    end
  end
end
