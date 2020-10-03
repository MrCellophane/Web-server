# ab -n 10000 -c 100 -p ./section_one/ostechnix.txt localhost:1234/
# head -c 100000 /dev/urandom > section_one/ostechnix_big.txt

require 'socket'
require './lib/response'
require './lib/request'
require './lib/request_parser'
MAX_EOL = 2

def handle_request(request, client)
  puts "#{client.peeraddr[3]} #{request.path}"

  p request

  response = Response.new(code: 200, data: "Hello, world!")

  response.send(client)

  client.shutdown
end

def handle_connection(client)
  request_parser = RequestParser.new()
  puts "Getting new client #{client}"
  
  while request_parser.not_finish?
    buf = client.recv(1)
    request_parser.parse(buf)
  end
  request = request_parser.request
  handle_request(request, client)
end

socket = TCPServer.new(ENV['HOST'], ENV['PORT'])

puts "Listening on #{ENV['HOST']}:#{ENV['PORT']}. Press CTRL+C to cancel."

loop do
  Thread.start(socket.accept) do |client|
    handle_connection(client)
  end
end

