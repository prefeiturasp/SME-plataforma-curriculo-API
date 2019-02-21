require 'rails_helper'

RSpec.describe Admin::LearningObjectivesHelper, type: :helper do
  describe 'Methods' do
    context "axes_collection_from_learning_objectives" do
      it 'return prompt, if learning objective is nil' do
        expected_response =  [["Selecione um componente curricular", nil, {:style=>"display: none;"}]]

        expect(helper.axes_collection_from_learning_objectives(learning_objective = nil)).to match_array(expected_response)
      end


      it 'return related axes, if learning objective contains curricular component' do
        curricular_component = create :curricular_component
        axis = create :axis, curricular_component: curricular_component

        learning_objective = create :learning_objective, curricular_component: curricular_component, axes: [axis]

        expected_response = [[axis.description, axis.id, { title: axis.description}]]

        expect(helper.axes_collection_from_learning_objectives(learning_objective)).to match_array(expected_response)
      end

      it 'returns [], if there are no axes of the selected curricular component' do
        curricular_component = create :curricular_component
        learning_objective = create :learning_objective, curricular_component: curricular_component

        expected_response = []

        expect(helper.axes_collection_from_learning_objectives(learning_objective)).to match_array(expected_response)
      end
    end
  end
end
