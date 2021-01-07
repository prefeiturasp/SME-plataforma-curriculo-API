ActiveAdmin.register Project do
  permit_params :title,
                :cover_image,
                :summary,
                :description,
                :owners,
                :development_year,
                :development_class,
                :teacher_id,
                :school_id,
                :regional_education_board_id,
                curricular_component_ids: [],
                knowledge_matrix_ids: [],
                student_protagonism_ids: [],
                segment_ids: [],
                stage_ids: [],
                year_ids: []

  config.filters = true

  filter :curricular_components
  filter :knowledge_matrices
  filter :student_protagonisms
  filter :segments
  filter :stages
  filter :years
  filter :development_year
  filter :development_class
  filter :title
  filter :summary
  filter :description
  filter :owners
  filter :regional_education_board
  filter :school
  filter :created_at

  controller do
    def destroy
      @project = Project.find(params[:id])
      flash[:error] = @project.errors.full_messages.join(',') unless @prooject.destroy
      redirect_to action: :index
    end
  end

  show do
    render 'show', context: self
  end

  form do |f|
    render 'form', f: f, project: project
  end

  index do
    selectable_column
    column :id
    column :teacher do |obj|
      if obj.teacher.present?
        if obj.teacher.name.present?
          teachers_name = obj.teacher.name
        else
          teachers_name = obj.teacher.user.name
        end
      else
        obj.advisors.each_with_index do |advisor, idx|
          if idx === 0
            teachers_name = advisor.name
          else
            teachers_name = "#{teachers_name}, #{advisor.name}"
          end
        end
      end
      teachers_name
    end
    column :owners
    column :regional_education_board
    column :school
    column :development_year
    column :development_class
    column :title
    column :summary
    actions
  end

end
