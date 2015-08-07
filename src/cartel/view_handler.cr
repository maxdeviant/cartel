class ViewHandler
    def initialize(directory)
        @directory = directory
    end

    def load(name)
        path = File.join(@directory, name)
        view = File.new(path)

        return view.read()
    end
end
