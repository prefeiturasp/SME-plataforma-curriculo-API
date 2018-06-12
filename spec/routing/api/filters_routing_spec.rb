require 'rails_helper'

RSpec.describe Api::FiltersController, type: :routing do
  describe 'routing' do
    context 'routes to #activity_sequence_index' do
      it 'show all' do
        expect(get: '/api/filtros').to route_to(
          'api/filters#index',
          format: 'json'
        )
      end
    end

    context 'routes to #activity_sequence_index_filter' do
      it 'find by year' do
        expect(get: '/api/filtros?year=2').to route_to(
          'api/filters#index',
          format: 'json',
          year: '2'
        )
      end

      it 'find by year and component' do
        expect(get: '/api/filtros?year=2&curricular_component_slug=component-test').to route_to(
          'api/filters#index',
          format: 'json',
          year: '2',
          curricular_component_slug: 'component-test'
        )
      end
    end
  end
end
