require "rss"

class FeedLoader
  class ItemLoader
    attr_reader :guid, :title, :url, :published_at

    def initialize(type, data)
      case type
      when "atom"
        @guid = data.id.content
        @title = data.title.content
        @url = data.link.href
        @published_at = data.published.content
      when "rss"
        @guid = data.guid.content
        @title = data.title
        @url = data.link
        @published_at = data.pubDate
      else
        raise "Not supported"
      end
    end
  end

  def initialize(url)
    @url = url
  end

  def title
    case data.feed_type
    when "atom"
      data.title.content
    when "rss"
      data.channel.title
    else
      raise "Not supported"
    end
  end

  def items
    data.items.map do |i|
      ItemLoader.new(data.feed_type, i)
    end
  end

  private

  def data
    @data ||= RSS::Parser.parse(content)
  end

  def content
    @content ||= Excon.get(@url, expects: 200).body
  end
end
