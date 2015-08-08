require "./cartel/*"
require "./cartel/api"
require "http/server"

module Cartel
    server = HTTP::Server.new(8080) do |request|
        puts "[#{request.method}] #{request.path}"

        users_api = API::Users.new()

        case request.path
        when "/"
            view = View.new("index", "default")
            view.render
        when "/play"
            unless request.method == "POST"
                return HTTP::Response.new(302, "", HTTP::Headers{"Location": "http://localhost:8080/"})
            end

            params = BodyParser.parse(request.body)

            user = API::Models::User.new(params["username"])

            if users_api.create(user)
                return HTTP::Response.new(302, "", HTTP::Headers{"Location": "http://localhost:8080/game/#{user.id}"})
            end

            HTTP::Response.new(400, "User already exists", HTTP::Headers{"Content-type": "text/plain"})
        when "/css/cartel.css"
            asset = Asset.new(request.path)
            asset.serve
        else
            view = View.new("404", "default")
            view.render(404)
        end
    end

    puts "Listening on :8080"
    server.listen
end
