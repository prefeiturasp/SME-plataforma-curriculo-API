module Admin
  module ActivitySequencesHelper
    def learning_objectives_collection
      LearningObjective.all.collect { |lo| [lo.code_and_description, lo.id] }
    end
  end
end
