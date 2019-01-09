class FaviconLoader
  attr_reader :host

  def initialize(host)
    @host = host
  end

  def data
    load_data!
    @data
  end

  private
  attr_reader :host

  def load_data!
    @data ||= check_for_html_tag || check_for_ico_file
  end

  # Check /favicon.ico
  def check_for_ico_file
    get_data! URI::HTTP.build(host: host, path: "/favicon.ico").to_s
  end


  # Check "shortcut icon" tag
  def check_for_html_tag
    uri = URI::HTTP.build(host: host, path: "/")
    res = Excon.get(uri.to_s)
    doc = Nokogiri::HTML(res.body)

    doc.xpath('//link[@rel="icon"]').each do |tag|
      taguri = URI.parse(tag["href"])
      taguri.host = uri.host if taguri.host.blank?
      taguri.scheme = "http" if taguri.scheme.blank?

      return get_data!(taguri.to_s)
    end

    nil
  end

  def get_data!(uri)
    res = Excon.get(uri, expects: 200)
    Base64.encode64(res.body)
  rescue Excon::Error
    nil
  end

end
