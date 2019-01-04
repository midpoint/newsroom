class FeedLoader

  def initialize(url)
    @url = url
  end
  delegate :title, to: :data
  delegate :entries, to: :data

  private

  def data
    @data ||= Feedjira.parse(content)
  end

  def content
    @content ||= Excon.get(@url, expects: 200).body
  end
end
