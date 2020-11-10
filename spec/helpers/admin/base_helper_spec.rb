require 'rails_helper'

RSpec.describe Admin::BaseHelper, type: :helper do
  describe 'activity_sequence_options' do
    context 'with is the first' do
      it 'return array [1]' do
        activity = build :activity
        expect(helper.activity_sequence_options(activity)).to match_array([1])
      end
    end

    context 'contains more than one' do
      it 'return activities number +1' do
        activity_sequence = create :activity_sequence
        activities = create_list :activity, 3, activity_sequence: activity_sequence
        new_activity = build :activity, activity_sequence: activity_sequence

        expect(helper.activity_sequence_options(new_activity)).to match_array([1, 2, 3, 4])
      end
    end
  end

  describe 'sequence_options' do
    context 'with is the first' do
      it 'return array [1]' do
        expect(helper.sequence_options(SustainableDevelopmentGoal)).to match_array([1])
        expect(helper.sequence_options(KnowledgeMatrix)).to match_array([1])
      end
    end

    context 'contains more than one' do
      it 'return activities number +1' do
        create_list :sustainable_development_goal, 2
        create_list :knowledge_matrix, 2

        expect(helper.sequence_options(SustainableDevelopmentGoal)).to match_array([1, 2])
        expect(helper.sequence_options(KnowledgeMatrix)).to match_array([1, 2])
      end
    end
  end

  describe 'sustainable_development_goals_collection' do
    it 'return name and id' do
      sdg_one = create :sustainable_development_goal, name: 'Test 1'
      sdg_two = create :sustainable_development_goal, name: 'Test 2'
      sdg_one.reload
      sdg_two.reload

      array_expected = [[sdg_one.sequence_and_name, sdg_one.id], [sdg_two.sequence_and_name, sdg_two.id]]

      expect(helper.sustainable_development_goals_collection).to match_array(array_expected)
    end
  end

  describe 'learning_objectives_activity_collection' do
    it 'return only learning objectives of activity sequence' do
      learning_objective = create :learning_objective
      activity_sequence = create :activity_sequence, learning_objective_ids: [learning_objective.id]
      activity = create :activity, activity_sequence: activity_sequence

      array_expected = [[learning_objective.code, learning_objective.id, { title: learning_objective.description }]]

      expect(helper.learning_objectives_activity_collection(activity)).to match_array(array_expected)
    end
  end

  describe 'show preview paths' do
    let(:activity) { create :activity }
    let(:activity_sequence) { create :activity_sequence, activity_ids: [activity.id] }

    it 'for the activity_sequence' do
      link_expected = "#{ENV['HTTP_STAGING_URL']}/sequencia/#{activity_sequence.slug}"
      expect(helper.activity_sequence_preview_path(activity_sequence.slug)).to eq(link_expected)
    end

    it 'for the activity' do
      link_expected = "#{ENV['HTTP_STAGING_URL']}/sequencia/#{activity_sequence.slug}/atividade/#{activity.slug}"
      expect(helper.activity_preview_path(activity_sequence.slug, activity.slug)).to eq(link_expected)
    end
  end

  describe 'Activity Sequence' do
    context 'books' do
      it 'toolbar options use only link' do
        options = [['link']]

        expect(books_toolbar_options).to match_array(options)
      end
    end
  end
end
