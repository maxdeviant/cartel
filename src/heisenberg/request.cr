module Heisenberg
    class Request
        getter params

        def initialize(@request, @params)
        end

        delegate body, @request
    end
end
