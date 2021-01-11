ActiveAdmin.register Project do
  permit_params :title,
                :cover_image,
                :summary,
                :description,
                :owners,
                :development_year,
                :development_class,
                :updated_by_admin,
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

  filter :title
  filter :regional_education_board
  filter :school
  filter :filter_by_email_cont, as: :string, label: 'E-mail'

  controller do
    def destroy
      @project = Project.find_by(slug: params[:id])
      flash[:error] = @project.errors.full_messages.join(',') unless @project.destroy
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
    column 'E-mail' do |obj|
      if obj.teacher.present?
        if obj.teacher.user.email.present?
          email = obj.teacher.user.email
        else
          email = "E-mail não cadastrado"
        end
      else
        email = "E-mail não cadastrado"
      end
    end
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
    column :created_at
    column :title
    column :regional_education_board
    column :school
    column :segments do |obj|
      segments = obj.segments.map {|segment| segment.name}
    end
    column :stages do |obj|
      stages = obj.stages.map {|stage| stage.name}
    end
    column :years do |obj|
      years = obj.years.map {|year| year.name}
    end
    actions
  end

end
