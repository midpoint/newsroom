require "rss"

class FeedLoader

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

  private

  def data
    @data ||= RSS::Parser.parse(content)
  end

  def content
    @content ||= Excon.get(@url).body
  end
end
