require 'socket'
require 'json' 

host = 'localhost'     # The web server
port = 2000                        # Default HTTP port
path = "/index.html"                 # The file we want 

# This is the HTTP request we send to fetch a file
	getRequest = "GET #{path} HTTP/1.0\n"
	badRequest = "GET lol HTTP/11.1\n"
	postRequest = "POST /thanks.html HTTP/1.0"

socket = TCPSocket.open(host,port)  # Connect to server
puts "Test [g]et request or test [p]ut request?"
requestType = gets.chomp
if (requestType == 'g') #get request
	socket.print(getRequest)               # Send request
elsif (requestType == 'b')
	socket.print(badRequest)
elsif (requestType == 'p')
	puts "Enter email"
	email = gets.chomp
	puts "Enter name"
	name = gets.chomp
	viking = {:viking => {:name=>name, :email=> email} }
	print "#{postRequest}#{viking.to_json}\n"
	socket.print "#{postRequest} #{viking.to_json}\n"
end
socket.print(badRequest)               # Send request
response = socket.read              # Read complete response
puts response
# Split response at first blank line into headers and body
#headers,body = response.split("\r\n\r\n", 2) 
#print body                          # And display it

