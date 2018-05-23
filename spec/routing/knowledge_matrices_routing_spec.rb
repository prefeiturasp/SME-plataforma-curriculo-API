require 'rails_helper'

RSpec.describe Api::V1::KnowledgeMatricesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'api/v1/knowledge_matrices').to route_to('api/v1/knowledge_matrices#index')
    end

    it 'routes to #show' do
      expect(get: 'api/v1/knowledge_matrices/1').to route_to('api/v1/knowledge_matrices#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: 'api/v1/knowledge_matrices').to route_to('api/v1/knowledge_matrices#create')
    end

    it 'routes to #update via PUT' do
      expect(put: 'api/v1/knowledge_matrices/1').to route_to('api/v1/knowledge_matrices#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: 'api/v1/knowledge_matrices/1').to route_to('api/v1/knowledge_matrices#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: 'api/v1/knowledge_matrices/1').to route_to('api/v1/knowledge_matrices#destroy', id: '1')
    end
  end
end
