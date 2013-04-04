require 'dbpedia'
require 'duck_duck_go'

class Inatri
  module Views
    class Overviewer < Layout
      attr_accessor :query, :abstract, :links, :related

      def title
        @query || false
      end

      def section
        'overviewer'
      end

      #def search?
      #  true
      #end

      def abstract?
        _ddg_fetch

        !!@abstract
      end

      def links?
        _ddg_fetch

        !!@links
      end

      def related?
        _ddg_fetch

        !!@related
      end

      # Fetch from DuckDuckGo
      def _ddg_fetch
        return if @fetched
        @fetched = true

        ddg = DuckDuckGo.new
        zci = ddg.zeroclickinfo(@query)

        @abstract = {
          text:   zci.abstract_text,
          url:    zci.abstract_url,
          source: zci.abstract_source,
        }

        @abstract = nil if @abstract[:text].nil? || @abstract[:text].empty?

        topics = zci.related_topics["_"]

        @related = _format_related(topics) if topics
      end

      def _format_related(topics)
        handle_topics(query, topics, @category ? 'category' : nil)
      end



  def handle_topics(query, topics, type)
    ret = []

    topics.each do |topic|
      if topic.is_a?(Hash) && topic.include?('Topics')
        # This returns something of the format:
        # {"Topics"=>
        #   [{"Result"=>
        #      ...},
        #    <snip>
        #    {"Result"=>
        #      ...}],
        #  "Name"=>"Category"}
        #
        # This should probably use 'Name', but it doesn't for now.
        ret += handle_topics(query, topic.topics, type)
        next
      end

      icon = topic.icon
      result = topic.result

      result.gsub!('<a href="http://duckduckgo.com/c/', '<a href="/overviewer?type=category&amp;q=')
      result.gsub!('<a href="http://duckduckgo.com/', '<a href="/overviewer?q=')
      result.gsub!('_','+')

      result.gsub!('?q=?q=', '?q=') # Is this because of 3 lines up?

      result_query = result.split('<a href="')[-1].split('">')[0]

      query_hash = CGI::parse(URI.parse(URI.encode(result_query)).query)
      result_type = (query_hash['type'] || ['']).last

      if (CGI.escape(query).downcase == result_query.downcase) && (result_type == type)
        next
      end

      ret << { icon: icon.url, result: result }
    end

    ret
  end

    end
  end
end
