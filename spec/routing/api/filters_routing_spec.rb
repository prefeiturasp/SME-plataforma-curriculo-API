require 'rails_helper'

RSpec.describe Api::FiltersController, type: :routing do
  describe 'routing' do
    context 'routes to #activity_sequence_index' do
      it 'show all' do
        expect(get: '/api/filtros/sequencia_atividade').to route_to(
          'api/filters#activity_sequence_index',
          format: 'json'
        )
      end
    end

    context 'routes to #activity_sequence_index_filter' do
      it 'find by year' do
        expect(get: '/api/filtros/sequencia_atividade/ano/2').to route_to(
          'api/filters#activity_sequence_index_filter',
          format: 'json',
          year: '2'
        )
      end

      it 'find by year and component' do
        expect(get: '/api/filtros/sequencia_atividade/ano/2/componente/component-test').to route_to(
          'api/filters#activity_sequence_index_filter',
          format: 'json',
          year: '2',
          curricular_component_friendly_id: 'component-test'
        )
      end
    end
  end
end
