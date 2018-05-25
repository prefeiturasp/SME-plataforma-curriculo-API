module Admin
  module BaseHelper
    def human_attribute_years
      LearningObjective.years.map { |k, _v| [I18n.t("activerecord.attributes.enums.years.#{k}"), k] }
    end

    def toolbar_options # rubocop:disable Metrics/MethodLength
      [%w[bold italic underline strike],
       ['blockquote', 'code-block'],
       [{ 'header': 1 }, { 'header': 2 }],
       [{ 'list': 'ordered' }, { 'list': 'bullet' }],
       [{ 'script': 'sub' }, { 'script': 'super' }],
       [{ 'indent': '-1' }, { 'indent': '+1' }],
       [{ 'direction': 'rtl' }],
       [{ 'size': ['small', false, 'large', 'huge'] }],
       [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
       ['image'],
       [{ 'color': [] }, { 'background': [] }],
       [{ 'font': [] }],
       [{ 'align': [] }],
       ['clean']]
    end
  end
end
