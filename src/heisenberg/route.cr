module Heisenberg
    class Route
        getter handler

        def initialize(@method, path, &@handler : Heisenberg::Context -> _)
            @components = path.split("/")
        end

        def match(method, components)
            return nil unless method == @method
            return nil unless components.length == @components.length

            params = nil

            @components.zip(components) do |route_component, request_component|
                if route_component.starts_with? ':'
                    params ||= {} of String => String
                    params[route_component[1 .. -1]] = request_component
                else
                    return nil unless route_component == request_component
                end
            end

            params ||= {} of String => String
            params
        end
    end
end