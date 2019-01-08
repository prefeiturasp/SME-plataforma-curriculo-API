module Api
  module Concerns
    module ActivitySequenceSearchable
      extend ActiveSupport::Concern

      private

      def search_activity_sequences
        query = params[:q].blank? ? '*' : params[:q]
        ActivitySequence.search(
          query,
          fields: list_fields,
          where: where,
          order: order_by,
          page: params[:page] || 0,
          per_page: per_page
        )
      end

      def list_fields
        ['main_curricular_component_name^10',
         'title^9',
         'activities_title^8',
         'keywords^7',
         'presentation_text^6',
         'activity_content_block_titles^5',
         'activity_content_block_bodies^4',
         'sustainable_development_goal_names^3',
         'learning_objective_descriptions^2']
      end

      def where
        options = { status: 'published' }
        %i[
          all_or_with_year all_or_with_main_curricular_component all_or_with_axes
          all_or_with_sustainable_development_goals all_or_with_knowledge_matrices
          all_or_with_learning_objectives
        ].each do |method|
          options.merge!(send(method.to_s))
        end

        options
      end

      def all_or_with_year
        return {} unless params[:years]
        { year: params[:years] }
      end

      def all_or_with_main_curricular_component
        return {} unless params[:curricular_component_slugs]
        { main_curricular_component_slug: params[:curricular_component_slugs] }
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

      def order_by
        order = { _score: :desc } # most relevant first - default
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

      def per_page
        return 30 if params[:per_page].to_i.zero? || params[:per_page].to_i > 100
        params[:per_page]
      end
    end
  end
end
