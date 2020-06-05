module Admin
  module YearsHelper
    def stage_collection(segment_id)
      stages = Stage.where(
        segment_id: segment_id
      )
      stages.collect do |stage|
        [stage.name, stage.id]
      end
    end
  end
end
