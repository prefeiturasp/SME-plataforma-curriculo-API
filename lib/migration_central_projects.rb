class MigrationCentralProjects
  attr_accessor :data_hash, :file, :table, :projects, :areas,
                :curriculumSubjects, :advisors, :participants, :tags,
                :projectArea, :projectCurriculumSubject, :projectAdvisor,
                :projectParticipant, :projectTag

  def initialize
  end

  def update_table(file, table)
    begin
      self.file = File.read(file)
      self.table = table
      self.data_hash = JSON.parse(self.file)["#{self.table}"]
    rescue StandardError => msg
      # display the system generated error message
      puts msg
    end
  end

  def populate_project
    Project.delete_all
    self.projects.each do |project|
      data = {
        old_id: project['codigoProjeto'],
        title: project['titulo'],
        school: project['escola'],
        dre: project['dre'],
        description: project['descricao'],
        summary: project['resumo'],
        owners: project['responsaveis']
      }
      Project.create(data)
    end
  end

  def populate_area
    Area.delete_all
    self.areas.each do |area|
      data = {
        old_id: area['Id'],
        name: area['Name']
      }
      Area.create(data)
    end
  end

  def populate_curriculum_subject
    CurriculumSubject.delete_all
    self.curriculumSubjects.each do |curriculum_subject|
      data = {
        old_id: curriculum_subject['codigoComponente'],
        name: curriculum_subject['nomeComponente']
      }
      CurriculumSubject.create(data)
    end
  end

  def populate_advisor
    Advisor.delete_all
    self.advisors.each do |advisor|
      data = {
        old_id: advisor['codigoIntegrante'],
        name: advisor['nomeIntegrante']
      }
      Advisor.create(data)
    end
  end

  def populate_participant
    Participant.delete_all
    self.participants.each do |participant|
      data = {
        old_id: participant['codigoIntegrante'],
        name: participant['nomeIntegrante']
      }
      Participant.create(data)
    end
  end

  def populate_tag
    Tag.delete_all
    self.tags.each do |tag|
      data = {
        old_id: tag['Id'],
        name: tag['Word']
      }
      Tag.create(data)
    end
  end

  def create_ref_project_area
    self.projectArea.each do |pa|
      project = Project.find_by(old_id: pa['codigoprojeto'])
      area = Area.find_by(old_id: pa['codigoarea'])
      project.areas << area
      project.save!
    end
  end

  def create_ref_project_curriculum_subject
    self.projectCurriculumSubject.each do |pcs|
      project = Project.find_by(old_id: pcs['codigoProjeto'])
      curriculum_subject = CurriculumSubject.find_by(old_id: pcs['codigoComponente'])
      project.curriculum_subjects << curriculum_subject
      project.save!
    end
  end

  def create_ref_project_advisor
    self.projectAdvisor.each do |pa|
      project = Project.find_by(old_id: pa['codigoProjeto'])
      advisor = Advisor.find_by(old_id: pa['codigoIntegrante'])
      project.advisors << advisor unless advisor.nil?
      project.save!
    end
  end

  def create_ref_project_participant
    self.projectParticipant.each do |pp|
      project = Project.find_by(old_id: pp['codigoProjeto'])
      participant = Participant.find_by(old_id: pp['codigoIntegrante'])
      project.participants << participant unless participant.nil?
      project.save!
    end
  end

  def create_ref_project_tag
    self.projectTag.each do |pt|
      project = Project.find_by(old_id: pt['codigoProjeto'])
      tag = Tag.find_by(old_id: pt['codigoPalavraChave'])
      project.tags << tag
      project.save!
    end
  end
end
# 
# central_projects = MigrationCentralProjects.new
#
# central_projects.update_table('./ta_na_rede_db/projects.json', 'projects')
# central_projects.projects = central_projects.data_hash
#
# central_projects.update_table('./ta_na_rede_db/areas.json', 'areas')
# central_projects.areas = central_projects.data_hash
#
# central_projects.update_table('./ta_na_rede_db/curriculum_subjects.json', 'curriculumSubjects')
# central_projects.curriculumSubjects = central_projects.data_hash
#
# central_projects.update_table('./ta_na_rede_db/advisors.json', 'advisors')
# central_projects.advisors = central_projects.data_hash
#
# central_projects.update_table('./ta_na_rede_db/participants.json', 'participants')
# central_projects.participants = central_projects.data_hash
#
# central_projects.update_table('./ta_na_rede_db/tags.json', 'tags')
# central_projects.tags = central_projects.data_hash
#
# central_projects.update_table('./ta_na_rede_db/project_area.json', 'projectArea')
# central_projects.projectArea = central_projects.data_hash
#
# central_projects.update_table('./ta_na_rede_db/project_curriculum_subject.json', 'projectCurriculumSubject')
# central_projects.projectCurriculumSubject = central_projects.data_hash
#
# central_projects.update_table('./ta_na_rede_db/project_advisor.json', 'projectAdvisor')
# central_projects.projectAdvisor = central_projects.data_hash
#
# central_projects.update_table('./ta_na_rede_db/project_participant.json', 'projectParticipant')
# central_projects.projectParticipant = central_projects.data_hash
#
# central_projects.update_table('./ta_na_rede_db/project_tag.json', 'projectTag')
# central_projects.projectTag = central_projects.data_hash
#
# central_projects.populate_project
# central_projects.populate_area
# central_projects.populate_curriculum_subject
# central_projects.populate_advisor
# central_projects.populate_participant
# central_projects.populate_tag
# central_projects.create_ref_project_area
# central_projects.create_ref_project_curriculum_subject
# central_projects.create_ref_project_advisor
# central_projects.create_ref_project_participant
# central_projects.create_ref_project_tag
