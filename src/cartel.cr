require "./cartel/*"
require "http/server"

module Cartel
    view_handler = ViewHandler.new(File.join(__DIR__, "views"))

    server = HTTP::Server.new(8080) do |request|
        puts "[#{request.method}] #{request.path}"

        case request.path
        when "/"
            HTTP::Response.ok "text/html", view_handler.load("index.html")
        else
            HTTP::Response.not_found
        end
    end

    puts "Listening on :8080"
    server.listen
end
