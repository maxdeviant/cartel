def request(method, path, &block : Heisenberg::Context -> _)
    Heisenberg::Handler::INSTANCE.add_route(method, path, &block)
end

def get(path, &block : Heisenberg::Context -> _)
    request("GET", path, &block)
end

def post(path, &block : Heisenberg::Context -> _)
    request("POST", path, &block)
end
