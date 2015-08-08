class Asset
    def initialize(@url)
        @asset_path = File.join(__DIR__, "../public", @url)
    end

    def serve : HTTP::Response
        unless File.file? @asset_path
            return HTTP::Response.new(404, "Could not find asset: #{@url}.", HTTP::Headers{"Content-type": "text/plain"})
        end

        contents = File.read(@asset_path)

        HTTP::Response.ok(get_content_type(@asset_path), contents)
    end

    private def get_content_type(file : String) : String
        content_types = {
            ".css": "text/css"
        }

        content_types.each do |extension, content_type|
            if file.ends_with? extension
                return content_type
            end
        end

        return "text/plain"
    end
end
