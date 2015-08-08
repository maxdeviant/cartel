module API
    class Users
        @@repository_path = File.join(__DIR__, "../../../data/users.json")

        def initialize

        end

        def list
            Array(API::Models::User).from_json(load_repository)
        end

        def create(user : API::Models::User) : Bool
            if exists?(user.id)
                return false
            end

            users = list

            users.push(user)

            save_repository(users.to_json)

            true
        end

        def exists?(id : String) : Bool
            users = list

            users.each do |user|
                if user.id == id
                    return true
                end
            end

            false
        end

        private def load_repository
            File.read(@@repository_path)
        end

        private def save_repository(contents : String)
            File.write(@@repository_path, contents)
        end
    end
end
