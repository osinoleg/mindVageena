#!/usr/bin/env ruby

require 'net/http'
require 'socket'
require 'json'

=begin sample data
{"eSense":{"attention":35,"meditation":77},"eegPower":{"delta":939051,"theta":140784,"lowAlpha":15860,"highAlpha":29600,"lowBeta":17269,"highBeta":16369,"lowGamma":3284,"highGamma":3757},"poorSignalLevel":0}
=end

def prepareForPost(jsonData)
    # pull out eSense json
    delim = "\"eSense\":"
    
    return nil if not jsonData.index(delim) 
    
    if jsonData.index("\"eSense\":") then
        puts "---"
        puts jsonData.index("\"eSense\":")
        puts delim.length
        startRange = jsonData.index("\"eSense\":") + delim.length
        puts jsonData.length
        endRange = jsonData[startRange..jsonData.length].index("}") + startRange
        puts endRange
        puts jsonData[endRange]
        puts jsonData[startRange..endRange] 
        puts "--"

        jsonData = jsonData[startRange..endRange]
    end

    return jsonData
end

def postToWebServer(jsonData)
    uri = URI('http://127.0.0.1:4567/mind_test') # TODO: change this uri
	req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
	#req.body = {attention: Random.rand(100), meditation: Random.rand(100)}.to_json
    req.body = jsonData
	res = Net::HTTP.start(uri.hostname, uri.port) do |http|
	  http.request(req)
	end

	#use this for debugging
	puts req  # actual request that is sent to your webserver
	puts req.body # this will show the json that is being sent
	puts res.body # this will show the response form your server (most likley, this will be the html for your page)
end

def quit(socket)
    socket.close
    puts "-----------\ndone\n-----------"
end

hostname = 'localhost'
port = 13854

s = TCPSocket.open(hostname, port)
s.setsockopt(Socket::SOL_SOCKET, Socket::SO_KEEPALIVE, true)

config = { 'enableRawOutput' => false, 'format' => "Json" }.to_json
s.write(config)

begin

while true do
    sleep(1.0)
    utf8 = s.recv(6048).to_s
    puts utf8
    prepared = prepareForPost(utf8)
    postToWebServer(prepared) if prepared
end

rescue Interrupt => e
    quit(s)
end

quit(s)

