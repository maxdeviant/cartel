require "cgi"
require "http/server"

module Heisenberg
    class Handler < HTTP::Handler
        INSTANCE = new

        def initialize
            @routes = [] of Route
        end

        def call(request)
            response = exec_request(request)
            response || call_next(request)
        end

        def add_route(method, path, &handler : Heisenberg::Context -> _)
            @routes << Route.new(method, path, &handler)
        end

        def exec_request(request)
            uri = request.uri
            components = uri.path.not_nil!.split("/")

            @routes.each do |route|
                params = route.match(request.method, components)

                if params
                    if query = uri.query
                        CGI.parse(query) do |key, value|
                            params[key] ||= value
                        end
                    end

                    heisenberg_request = Request.new(request, params)
                    context = Context.new(heisenberg_request)

                    begin
                        body = route.handler.call(context).to_s
                        content_type = context.response?.try(&.content_type) || "text/plain"

                        return HTTP::Response.ok(content_type, body)
                    rescue ex
                        return HTTP::Response.error("text/plain", ex.to_s)
                    end
                end
            end

            nil
        end
    end
end
