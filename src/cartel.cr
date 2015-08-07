require "./cartel/*"
require "http/server"

module Cartel
    server = HTTP::Server.new(8080) do |request|
        puts request
        HTTP::Response.ok "text/json", "Hello World!"
    end

    puts "Listening on :8080"
    server.listen
end
