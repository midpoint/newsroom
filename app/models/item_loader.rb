# frozen_string_literal: true

class ItemLoader

  def initialize(url)
    @url = url
  end

  def title
    data.css('title').text
  end

  private

  def data
    @data ||= Nokogiri::HTML(content)
  end

  def content
    @content ||= Request.get(@url).body
  end
end
