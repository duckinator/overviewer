require 'open-uri'
require 'json'
require 'cgi'
require 'duck_duck_go'

class DDG
  attr_reader :json, :is_category, :type, :query, :summary, :related,
              :article, :title, :name

  alias :'category?' :is_category

  def initialize(query)
    @query = query

    @json = fetch_json(query)

    #pp @json
    update!
  end

  def method_missing(meth, *args, &block)
    key = meth.to_s.gsub('_', '')

    possible_keys = @json.keys.grep(Regexp.compile("^#{key}$", 'i'))
    key = possible_keys[0]

    if @json.keys.include?(key)
      ret = @json[key]
      ret = nil if ret.empty?
      ret
    else
      super # Default method_missing handler.
    end
  end

  def uses_wikipedia?
    abstract_source == 'Wikipedia'
  end

  def wikipedia_article
    return nil unless uses_wikipedia?

    url = abstract_url

    url.sub!(/^https.*\/wiki\//, '')
    url.sub!(/_\(disambiguation\)$/, '')
    url
  end

  def fetch_raw(query)
    open("http://duckduckgo.com/?q=#{CGI.escape(query)}&format=json").read
  end

  def fetch_json(query)
    JSON.parse(fetch_raw(query))
  end


  def update!
    @is_category = (@type == 'category')

    @related = format_topics(@query, json['RelatedTopics'] || [], @type)
    @article = wikipedia_article
    @summary = summary || ''

    if definition && !category?
      @summary += quote(definition, definition_source, "")
    end

    if abstract && !is_category
      @summary += quote(abstract, abstract_source, abstract_url)
    end

=begin
    if related_topics
      related_topics.each do |topic|
        pp topic
        _puts topic['Text']
      end
    end
=end

    @is_category ||= (!definition && !abstract)

    @type = 'category' if category?

    #@article = nil unless uses_wikipedia? && !@summary.empty?
  end

=begin
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

    @related = format_topics(@query, @topics, @type) if topics
  end
=end

  def format_topics(query, topics, type)
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
        ret += format_topics(query, topic['Topics'], type)
        next
      end

      icon = topic['Icon']
      result = topic['Result']

      result.gsub!('<a href="https://duckduckgo.com/c/', '<a href="/overviewer?type=category&amp;q=')
      result.gsub!('<a href="https://duckduckgo.com/', '<a href="/overviewer?q=')
      result.gsub!('_','+')

      result_query = result.split('<a href="')[-1].split('">')[0]

      query_hash = CGI::parse(URI.parse(URI.encode(result_query)).query)
      result_type = (query_hash['type'] || ['']).last

      if (CGI.escape(query).downcase == result_query.downcase) && (result_type == type)
        next
      end

      ret << { icon: icon['URL'], result: result }
    end

    ret
  end

  def quote(text, source, url)
    <<-EOF
<figure>
  <blockquote>#{text}</blockquote>
  <figcaption><a href=\"#{url}\">#{source}</a></figcaption>
</figure>
    EOF
  end
end
