require 'digest'
require 'json'
require 'base64'

class AuthService
    def get_hashed_and_salted_pass(password, salt)
        Digest::SHA256.hexdigest(password + salt)
    end

    def get_salt
        rand(36**25).to_s(36)
    end

    def validate_password(expected, actual)
        expected == actual
    end

    def get_token(user_id)
        secret_string = File.read(Rails.configuration.secretlocation)
        payload = { "user_id": user_id }.to_json
        signature = { "signature": Digest::SHA256.hexdigest(secret_string + payload) }.to_json
        Base64.encode64(payload) + "." + Base64.encode64(signature)
    end

    def validate_token(token)
        begin
            secret_string = File.read(Rails.configuration.secretlocation)
            token_parts = token.split(".")
            payload = Base64.decode64(token_parts[0])
            signature = JSON.parse(Base64.decode64(token_parts[1])).values[0]
            expected_signature = Digest::SHA256.hexdigest(secret_string + payload)
            expected_signature = signature
        rescue
          false
        end
    end
end