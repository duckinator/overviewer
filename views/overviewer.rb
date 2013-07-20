require 'inatri/duckduckgo'
require 'inatri/dbpedia'
require 'pp'

class Inatri
  module Views
    class Overviewer < Layout
      attr_accessor :query, :abstract, :links, :related, :name, :title

      def title
        @title || @query
      end

      def search?
        true
      end

      def abstract?  
        fetch!

        !!@abstract
      end

      def links?
        fetch!

        !!@links
      end

      def related?
        fetch!

        !!@related
      end

      # Fetch from DuckDuckGo
      def fetch!
        return if @fetched
        @fetched = true

        ddg = DDG.new(@query)

        @summary = ddg.summary
        @related = ddg.related
        @type    = ddg.type
        @article = ddg.article
        @title   = ddg.title
        @name    = ddg.name
        @query   = ddg.query

        if @query && !@query.empty? && !@summary.empty?
          @wikipedia = @article

          if @wikipedia
            dbp = DBPedia.new(@article, @type)

            @title = @name = dbp.name if dbp.name.is_a?(String)

            @wp_url = dbp.url
            @summary = dbp.summary || dbp.comment
            @summary_source_url  = dbp.url
            @summary_source_name = 'Wikipedia'

            @homepage = dbp.homepage

            @geo_lat  = dbp.geo_lat
            @geo_long = dbp.geo_long
            @geo_full = dbp.geo_full

            if @geo_lat && @geo_long
              @map_url = "https://maps.google.com/maps?q=#{CGI.escape(query)}&sll=#{@geo_lat},#{@geo_long}"
              @map_site_name = 'Google Maps'
            end

            # @links is an or'd (||) list of URLs,
            # so it's truthy if there's a URL to show.
            @links = {
              'homepage'  => {
                'href' => @homepage,
              },
              'wikipedia' => {
                'href' => @wp_url,
              },
              'map' => {
                'href' => @map_url,
                'site_name' => @map_site_name,
              },
            }
          else
            # Not using this since we can't guarantee it's properly attributed.
            @noresults = true
            #@raw_summary = summary
          end
        end

        @type = 'category' if @summary.nil? || @summary.empty?
      end
    end
  end
end
