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
            where: { 
              status: 'published'
            },
            order: order_by,
            page: params[:page] || 0,
            per_page: 30
          )
      end
    
      def list_fields
        [
          'main_curricular_component_name^10',
          'title^9',
          'activities_title^8',
          'keywords^7',
          'presentation_text^6',
          'activity_content_block_titles^5',
          'activity_content_block_bodies^4',
          'sustainable_development_goal_names^3',
          'learning_objective_descriptions^2',
        ]
      end

      def order_by
        order = { _score: :desc } # most relevant first - default
        order = {
          "#{params[:order_by]}" => { "order" => "#{params[:sort]}" }
        } if valid_order_by?

        order
      end

      def valid_order_by?
        whitelist_order.include?(params[:order_by]&.to_sym) && whitelist_sort.include?(params[:sort]&.to_sym)
      end

      def whitelist_order
        [ :title, :created_at ]
      end

      def whitelist_sort
        [ :asc, :desc ]
      end
    end
  end
end
