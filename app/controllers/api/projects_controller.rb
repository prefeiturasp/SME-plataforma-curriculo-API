module Api
  class ProjectsController < ApiController

    def create
      project_attributes = {
        teacher_id: project_params[:teacher_id],
        regional_education_board_id: project_params[:regional_education_board_id],
        school_id: project_params[:school_id],
        development_year: project_params[:development_year],
        development_class: project_params[:development_class],
        owners: project_params[:owners],
        title: project_params[:title],
        summary: project_params[:summary],
        description: project_params[:description],
        learning_objective_ids: project_params[:learning_objective_ids].split(','),
        curricular_component_ids: project_params[:curricular_component_ids].split(','),
        knowledge_matrix_ids: project_params[:knowledge_matrix_ids].split(','),
        student_protagonism_ids: project_params[:student_protagonism_ids].split(','),
        segment_ids: project_params[:segment_ids].split(','),
        stage_ids: project_params[:stage_ids].split(','),
        year_ids: project_params[:year_ids].split(',')
      }
      project = Project.create(project_attributes)
      project_params[:project_links_attributes].split(',').each do |link|
        ProjectLink.create({project_id: project.id, link: link})
      end
      project.cover_image.attach(project_params[:cover_image])
      if project.save
        render json: project, status: :created
      else
        render json: project.errors, status: :unprocessable_entity
      end
    end

    private

    def project_params
      params.require(:project).permit(
        :teacher_id,
        :regional_education_board_id,
        :school_id,
        :development_year,
        :development_class,
        :owners,
        :title,
        :summary,
        :description,
        :cover_image,
        :learning_objective_ids,
        :curricular_component_ids,
        :knowledge_matrix_ids,
        :student_protagonism_ids,
        :segment_ids,
        :stage_ids,
        :year_ids,
        :project_links_attributes
      )
    end

    def set_project
      @project = Project.find_by(id: params[:id])
    end
  end
end



# segment_ids: project_params[:segment_ids].split(','),
# stage_ids: project_params[:stage_ids].split(','),
# year_ids: project_params[:year_ids].split(',')
