module Api
  module Concerns
    module SearchkickPagination
      def searchkick_paginate(scope)
        @scope = scope
        pages = page_numbers
        links = create_links(pages)

        headers['Link'] = links.join(', ') unless links.empty?
        headers['Per-Page'] = scope.per_page
        headers['Total'] = scope.total_count
      end

      def create_links(pages)
        url_without_params = request.url.split('?').first

        links = []
        pages.each do |key, value|
          new_params = request.query_parameters.merge(page: value, per_page: per_page)
          links << "<#{url_without_params}?#{new_params.to_param}>; rel=\"#{key}\""
        end
        links
      end

      def page_numbers
        pages = {}
        pages[:first] = first_page if first_page.present?
        pages[:prev] = previous_page if previous_page
        pages[:next] = next_page if next_page
        pages[:last] = last_page if last_page
        pages
      end

      def previous_page
        @scope.current_page - 1 if @scope.current_page > 1
      end

      def next_page
        @scope.current_page + 1 if @scope.current_page < @scope.total_pages
      end

      def last_page
        @scope.total_pages if @scope.total_pages > 1 && @scope.current_page < @scope.total_pages
      end

      def first_page
        1 if @scope.total_pages > 1 && @scope.current_page > 1
      end
    end
  end
end
