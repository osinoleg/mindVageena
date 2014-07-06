require 'net/http'
require 'json'

def emulateMind()
	uri = URI('http://127.0.0.1:4567/mind_test') # TODO: change this uri
	req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
	req.body = {attention: Random.rand(100), meditation: Random.rand(100)}.to_json
	res = Net::HTTP.start(uri.hostname, uri.port) do |http|
	  http.request(req)
	end

	#use this for debugging
	puts req  # actual request that is sent to your webserver
	puts req.body # this will show the json that is being sent
	puts res.body # this will show the response form your server (most likley, this will be the html for your page)
end


emulateMindInterval = 0.5
delta = emulateMindInterval
prevTime = Time.now.to_i 

while true 
	if delta >= emulateMindInterval then
		emulateMind()
		delta = 0
	end

	delta += (Time.now.to_i - prevTime)
	prevTime = Time.now.to_i
end


