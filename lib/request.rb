class Request
  attr_reader :method, :path, :version, :headers, :body

  def initialize(method, path, version)
    @method = method
    @path = path
    @version = version
    @headers = {}
    @body = ""
  end

  def add_header (key, value)
    @headers[key.downcase] = value
  end

  def has_body?
    @headers.key?("content-length")
  end

  def content_length
    @headers["content-length"].to_i
  end

  def add_body(body)
    @body = body
  end
end
