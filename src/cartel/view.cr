class View
    def initialize(@name : String, @layout = "" : String)
        @view_path = get_view_path(@name)
    end

    def render : String
        compile
    end

    def render(status_code : Int32) : HTTP::Response
        HTTP::Response.new(status_code, compile, HTTP::Headers{"Content-type": "text/html"})
    end

    private def compile : String
        if @layout.empty?
            view_html = File.read(@view_path)

            view_html = compile_partials(view_html)

            return view_html
        else
            return compile(@layout)
        end
    end

    private def compile(layout : String) : String
        layout_path = get_layout_path(layout)

        layout_html = File.read(layout_path)

        layout_html = compile_partials(layout_html)

        block_pattern = /{{.*block.*}}/

        block_matches = layout_html.scan(block_pattern)

        block_matches.each do |match|
            block = match[0].split('"')[1]

            unless File.file? @view_path
                puts "Could not find view: #{@view_path}."

                next
            end

            view_html = File.read(@view_path)

            view_html = compile_partials(view_html)

            layout_html = layout_html.gsub(match[0], view_html)
        end

        return layout_html
    end

    private def compile_partials(html : String) : String
        partial_pattern = /{{.*include.*}}/

        partial_matches = html.scan(partial_pattern)

        partial_matches.each do |match|
            partial = match[0].split('"')[1]
            partial_path = get_partial_path(partial)

            unless File.file? partial_path
                puts "Could not find partial: #{partial_path}."

                next
            end

            partial_html = File.read(partial_path)

            unless partial_html.scan(partial_pattern).empty?
                partial_html = compile_partials(partial_html)
            end

            html = html.gsub(match[0], partial_html)
        end

        return html
    end

    private def get_view_directory : String
        File.join(__DIR__, "../views")
    end

    private def get_layout_path(name : String) : String
        File.join(get_view_directory, "_layouts", to_html(name))
    end

    private def get_view_path(name : String) : String
        File.join(get_view_directory, to_html(name))
    end

    private def get_partial_path(name : String) : String
        File.join(get_view_directory, "_partials", to_html(name))
    end

    private def to_extension(name : String, extension : String) : String
        if !name.ends_with? extension
            return name + extension
        end

        return name
    end

    private def to_html(name : String) : String
        to_extension(name, ".html")
    end
end
