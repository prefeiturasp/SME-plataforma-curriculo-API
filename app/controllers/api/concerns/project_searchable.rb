module Api
  module Concerns
    module ProjectSearchable
      extend ActiveSupport::Concern
      include Api::Concerns::SearchkickPagination

      private

      def search_projects
        query = params[:q].blank? ? '*' : params[:q]
        Project.search(
          query,
          fields: ['title^1'],
          where: where,
          order: order_by,
          load: false,
          page: page,
          per_page: per_page
        )
      end

      def project_ids_from_search(search_result)
        search_result.hits.map { |h| h['_id'] }
      end

      def list_fields
        []
      end

      def where
        options = { old_id: nil }
        %i[ all_or_with_axes all_or_with_sustainable_development_goals
          all_or_with_knowledge_matrices all_or_with_learning_objectives
          all_or_with_segments all_or_with_stages all_or_with_year
          all_or_with_curricular_components
        ].each do |method|
          options.merge!(send(method.to_s))
        end

        options
      end

      def all_or_with_curricular_components
        return {} unless params[:curricular_component_ids]
        { curricular_component_ids: params[:curricular_component_ids] }
      end

      def all_or_with_year
        return {} unless params[:year_ids]
        { year_ids: params[:year_ids] }
      end

      def all_or_with_axes
        return {} unless params[:axis_ids]
        { axis_ids: params[:axis_ids] }
      end

      def all_or_with_sustainable_development_goals
        return {} unless params[:sustainable_development_goal_ids]
        { sustainable_development_goal_ids: params[:sustainable_development_goal_ids] }
      end

      def all_or_with_knowledge_matrices
        return {} unless params[:knowledge_matrix_ids]
        { knowledge_matrix_ids: params[:knowledge_matrix_ids] }
      end

      def all_or_with_learning_objectives
        return {} unless params[:learning_objective_ids]
        { learning_objective_ids: params[:learning_objective_ids] }
      end

      def all_or_with_segments
        return {} unless params[:segment_ids]
        { segment_ids: params[:segment_ids] }
      end

      def all_or_with_stages
        return {} unless params[:stage_ids]
        { stage_ids: params[:stage_ids] }
      end

      def order_by
        order = { title: :asc } # most relevant first - default
        if valid_order_by?
          order = {
            params[:order_by].to_s => { 'order' => params[:sort].to_s }
          }
        end

        order
      end

      def valid_order_by?
        whitelist_order.include?(params[:order_by]&.to_sym) && whitelist_sort.include?(params[:sort]&.to_sym)
      end

      def whitelist_order
        %i[title created_at]
      end

      def whitelist_sort
        %i[asc desc]
      end

      def page
        params[:page].to_i || 0
      end

      def per_page
        return default_per_page if params[:per_page].to_i.zero? || params[:per_page].to_i > max_per_page
        params[:per_page].to_i
      end

      def default_per_page
        Project.default_per_page
      end

      def max_per_page
        Project.max_per_page
      end
    end
  end
end
