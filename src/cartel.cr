require "./cartel/*"
require "./cartel/api"
require "./heisenberg"

module Cartel
    users_api = API::Users.new()

    get "/" do |req|
        req.response.content_type = "text/html"

        view = View.new("index", "default")
        view.render
    end

    post "/play" do |req|
        params = BodyParser.parse(req.body)

        user = API::Models::User.new(params["username"])

        if users_api.create(user)
            return HTTP::Response.new(302, "", HTTP::Headers{"Location": "http://localhost:8080/game/#{user.id}"})
        end
    end

    get "/game/:id" do |req|
        user = users_api.find_one_by_id(req.params["id"])

        req.response.content_type = "text/json"
        user.to_json
    end
end
