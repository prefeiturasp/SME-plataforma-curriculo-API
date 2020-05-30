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

    def render_cover_image(current_value)

    end
  end
end
