require "./heisenberg/*"

at_exit do
    handlers = [] of HTTP::Handler

    handlers << HTTP::LogHandler.new
    handlers << Heisenberg::Handler::INSTANCE
    handlers << HTTP::StaticFileHandler.new("./public")

    server = HTTP::Server.new(8080, handlers)

    puts "Listening on :8080"
    server.listen
end
