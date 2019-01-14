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
    @content ||= Excon.get(@url, expects: 200).body
  rescue Excon::Error::Redirection => e
    @url = e.response[:headers]["Location"]
    content
  end
end
