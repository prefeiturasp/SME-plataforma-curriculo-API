ActiveAdmin.register ActivitySequence, as: 'Activity Sequences Report' do
  actions :all, except: [:new]

  controller do
    def scoped_collection
      ActivitySequence.evaluateds
    end
  end

  csv do
    column :title
    Rating.enableds.each do |rating|
      column rating.description.to_sym do |activity_sequence|
        number_with_precision(activity_sequence.average_by_rating_type(rating.id), precision: 2)
      end
    end
    column :total_evaluations, &:total_evaluations
  end

  index download_links: [:csv] do
    render 'admin/activity_sequence_reports/index', context: self
  end
end
