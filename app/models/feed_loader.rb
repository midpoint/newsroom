require "rss"

class FeedLoader
  class ItemLoader
    attr_reader :guid, :title, :url, :published_at

    def initialize(data)
      case data
      when RSS::Atom::Feed::Entry
        @guid = data.id.content
        @title = data.title.content
        @url = data.link.href
        @published_at = data.published.content
      when RSS::Rss::Channel::Item
        @guid = data.guid.content
        @title = data.title
        @url = data.link
        @published_at = data.pubDate
      when RSS::RDF::Item
        @guid = data.about
        @title = data.title
        @url = data.link
        @published_at = data.dc_date
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
      ItemLoader.new(i)
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
