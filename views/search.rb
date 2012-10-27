class Inatri
  module Views
    class Search < Layout
      attr_accessor :query

      def title
        @query || false
      end

      def section
        'search'
      end

      def related
        'Related.'
      end
    end
  end
end
