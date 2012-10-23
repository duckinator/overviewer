class Inatri
  module Views
    class Layout < Mustache
      def site
        'inatri'
      end

      def title
        @title
      end

      def section
        ''
      end

      def related
        'Related.'
      end

      def header
        ''
      end
    end
  end
end
