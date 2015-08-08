require "./cartel/*"
require "http/server"

module Cartel
    server = HTTP::Server.new(8080) do |request|
        puts "[#{request.method}] #{request.path}"

        case request.path
        when "/"
            view = View.new("index", "default")
            view.render
        else
            view = View.new("404", "default")
            view.render(404)
        end
    end

    puts "Listening on :8080"
    server.listen
end
