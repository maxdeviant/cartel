module API::Models
    class User
        json_mapping({
            id: String,
            username: String
        })

        def initialize(@username)
            @id = generate_id
        end

        private def generate_id
            bank = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split("").shuffle

            id = ""

            (0..7).each do
                id += bank.sample
            end

            return Base64.urlsafe_encode64(id)
        end
    end
end
