# frozen_string_literal: true

class Request
  def self.get(url, expects: 200)
    Excon.get(url, expects: expects, omit_default_port: true)
  end
end
