require 'socket'               # Get sockets from stdlib
require 'json'

server = TCPServer.open(2000)  # Socket to listen on port 2000
#currentDirectory = "~/Gits/RubyOnTheWeb" #Find a way to do this dynamically
loop {                         # Servers run forever
  client = server.accept       # Wait for a client to connect
  request = client.gets
  requestType, path, HTTPversion, vikingString = request.split(' ')
  if (requestType == "GET" && File.exists?(path[1...path.size])) #GET Request Recieved
    fileRequested = File.new(path[1...path.size], 'r')
    message = fileRequested.read
    fileRequested.close
    client.print "HTTP/1.0 200 OK\nDate:#{Time.now.ctime}\nContent-Type: text/html\nContent-Length: #{message.size}\n\n"
    client.print message
  elsif (requestType == "POST" && File.exists?(path[1...path.size]))
    params = JSON.parse(vikingString)
    fileRequested = File.new(path[1...path.size], 'r')
    message = fileRequested.read
    message.gsub!("<%= yield %>", "<li>Name: #{params["viking"]["name"]}</li><li>Email: #{params["viking"]["email"]}</li>")
    client.print(params["viking"]["name"])
    client.print(params["viking"]["email"])
    client.print "HTTP/1.0 200 OK\nDate:#{Time.now.ctime}\nContent-Type: text/html\nContent-Length: #{message.size}\n\n"
    client.print message
  else
    client.print "HTTP/1.0 404 Not Found\nDate:#{Time.now.ctime}\n\n"
  end
  client.puts(Time.now.ctime)  # Send the time to the client
  client.puts("Closing the connection. Bye!")
  client.close                 # Disconnect from the client
}

