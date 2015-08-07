class View
    def initialize(@name : String)
        @path = File.join(__DIR__, "../views", to_html(name))
    end

    def render
        HTTP::Response.ok("text/html", compile)
    end

    private def compile
        view = File.read(@path)

        partials = view.scan(/{{.*.}}/)

        partials.each do |partial|
            partial_name = partial[0].split('"')[1]

            partial_name = to_html(partial_name)

            partial_path = File.join(__DIR__, "../views/_partials", partial_name)

            unless File.file? partial_path
                puts "Could not find #{partial_path}."

                next
            end

            partial_contents = File.read(partial_path)

            view = view.gsub(partial[0], partial_contents)
        end

        return view
    end

    private def to_extension(name, extension)
        if !name.ends_with? extension
            return name + extension
        end

        return name
    end

    private def to_html(name)
        to_extension(name, ".html")
    end
end
