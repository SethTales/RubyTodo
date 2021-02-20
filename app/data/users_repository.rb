class UsersRepository
    def user_exists(username)
        User.where({username: username}).exists?
    end

    def create_user(username, hashed_pass, salt)
        User.create(username: username, password: hashed_pass, salt: salt)
    end

    def get_user(username)
        User.find_by(username: username)
    end
end