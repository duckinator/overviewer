class Inatri
  module Views
    class Search < Layout
      def title
        @query || false
      end

      def section
        'search'
      end

      def related
        'Related.'
      end

      def header
<<EOF
	<form action="/" method="GET">
		<input type="text" id="q" name="q" value="#{ @query }">
		<input type="submit" value="Search">
	</form>
EOF
      end
    end
  end
end
