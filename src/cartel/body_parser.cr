class BodyParser
    def self.parse(body : String?) : Hash
        parsed_params = {} of String => String

        params = body.to_s.split('&')

        params.each do |param|
            name, value = param.split('=')

            parsed_params[name] = value
        end

        return parsed_params
    end
end
