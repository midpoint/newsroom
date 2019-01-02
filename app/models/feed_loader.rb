require "rss"

class FeedLoader

  def initialize(url)
    @url = url
  end

  def title
    data.title.content
  end

  private

  def data
    @data ||= RSS::Parser.parse(content)
  end

  def content
    @content ||= Excon.get(@url).body
  end
end
