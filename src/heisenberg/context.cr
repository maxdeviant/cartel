module Heisenberg
    class Context
        getter request

        def initialize(@request)
        end

        def response : Response
            @response ||= Response.new
        end

        def response? : Nil | Response
            @response
        end

        def params
            request.params
        end

        def body
            request.body
        end
    end
end
