class Inatri
  module Views
    class Layout < Mustache
      def site
        'Inatri'
      end

      def title
        @title
      end

      def section
        nil
      end

      def search_submit_url
        '/' + section
      end

      def search?
        false
      end
    end
  end
end
