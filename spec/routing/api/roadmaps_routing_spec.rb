require 'rails_helper'

RSpec.describe Api::RoadmapsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/roteiros').to route_to('api/roadmaps#index', format: 'json')
    end
  end
end
