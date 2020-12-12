module Api
  class ProjectsController < ApiController
    include Api::Concerns::ProjectSearchable

    before_action :set_project, only: %i[show]
    before_action :set_teacher, only: %i[load_projects save_project delete_project]
    before_action :set_collection, only: %i[load_projects save_project delete_project]
    before_action :set_collection_project, only: %i[delete_project]
    before_action :check_collection_owner, only: %i[save_project]

    def show
      @teachers = ""
      if @project.teacher.present?
        @teachers = @project.teacher.name.titleize if @project.teacher.name.present?
        @teachers = @project.teacher.user.name.titleize if @project.teacher.user.name.present?
      elsif @project.advisors.present?
        @project.advisors.map(&:name).each do |advisor|
          if @teachers.empty?
            @teachers = advisor.titleize
          else
            @teachers = "#{@teachers}, #{advisor.titleize}"
          end
        end
      end
      render :show
    end

    def index
      projects = search_projects
      searchkick_paginate(projects)
      project_ids = project_ids_from_search(projects)
      @projects = Project.where_id_with_includes(project_ids)
    end

    def save_project
      @collection_project = @collection.collection_projects
                                                 .build(collection_projects_params)
      if @collection_project.save
        @project = @collection_project.project # find because show json
        render json: @project, status: :created
      else
        render json: @collection_project.errors, status: :unprocessable_entity
      end
    end

    def load_projects
      render_unauthorized_resource && return if @collection && !user_signed_in?
      @projects = @collection.projects.includes(:collection_projects)
      @projects = paginate(@projects)
    end

    def delete_project
        @collection_project.destroy
    end

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

    def collection_projects_params
      params.require(:collection_project).permit(:project_id, :sequence)
    end

    def check_user_permission
      render_no_content && return unless @teacher
      render_unauthorized_resource && return \
        if current_user&.id != @teacher&.user_id
    end

    def set_teacher
      return if params[:teacher_id].blank?
      @teacher = Teacher.find_by(id: params[:teacher_id])
      check_user_permission
    end

    def set_collection
      return if params[:teacher_id].blank? && params[:collection_id].blank?
      @collection = Collection.find(params[:collection_id])
    end

    def set_project
      @project = Project.find_by(slug: params[:slug])
    end

    def set_collection_project
      return unless @collection
      @collection_project = @collection.collection_projects
                                                 .find_by(project_id: params[:id])

      render_no_content && return unless @collection_project
    end

    def check_collection_owner
      return unless @collection
      render_unauthorized_resource && return if @collection.teacher.user.id != current_user.id
    end
  end
end
