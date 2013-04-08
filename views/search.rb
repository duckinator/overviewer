class Inatri
  module Views
    class Search < Layout
      attr_accessor :query

      def title
        @query || false
      end

      def search?
        true
      end
    end
  end
end
