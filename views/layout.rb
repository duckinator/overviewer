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
        nil
      end
    end
  end
end
