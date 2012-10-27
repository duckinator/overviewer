class Inatri
  module Views
    class Overviewer < Layout
      attr_accessor :query

      def title
        @query || false
      end

      def section
        'overviewer'
      end

      def search?
        true
      end
    end
  end
end
