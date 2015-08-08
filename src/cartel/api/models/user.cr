module API::Models
    class User
        json_mapping({
            id: String,
            username: String
        })

        def initialize(@username : String)
            @id = generate_id
        end

        private def generate_id : String
            bank = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split("").shuffle

            id = ""

            (0..7).each do
                id += bank.sample
            end

            Base64.urlsafe_encode64(id)
        end
    end
end
