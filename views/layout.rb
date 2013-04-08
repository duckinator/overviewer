class Inatri
  module Views
    class Layout < Mustache
      def site
        'Inatri'
      end

      def title
        @title
      end

      def query?
        @query && @query.is_a?(String) && !@query.empty?
      end

      # In Inatri::Views::Layout this would return 'layout',
      # in Inatri::Views::Index this would return 'index', etc
      def section
        self.class.name.split(':').last.downcase
      end

      def title_prefix
        nil
      end

      def overviewer_submit_url
        '/overviewer'
      end

      def search?
        true
      end

      def index?
        false
      end
    end
  end
end
