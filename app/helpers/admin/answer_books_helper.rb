module Admin
  module AnswerBooksHelper
    def stage_collection(segment_id)
      stages = Stage.where(
        segment_id: segment_id
      )
      stages.collect do |stage|
        [stage.name, stage.id]
      end
    end

    def year_collection(stage_id)
      years = Year.where(
        stage_id: stage_id
      )
      years.collect do |year|
        [year.name, year.id]
      end
    end
  end
end
