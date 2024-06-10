class ApplicationController < ActionController::API
    before_action :authorized

    def encode_token(payload)
      JWT.encode(payload, 'yourSecret')
    end
  
    def auth_header
      # { Authorization: 'Bearer <token>' }
    #   puts request.headers['Authorization']
      request.headers['Authorization']
      
    end
  
    def decoded_token
        puts "decoding: #{auth_header}"
      if auth_header
        token = auth_header.split(' ')[1]
        puts "token got: #{token}"
        # header: { 'Authorization': 'Bearer <token>' }
        begin
          JWT.decode(token, 'yourSecret', true, algorithm: 'HS256')
        rescue JWT::DecodeError
          nil
        end
      end
    end
  
    def logged_in_user
      if decoded_token
        user_id = decoded_token[0]['user_id']
        @user = User.find_by(id: user_id)
      end
    end
  
    def logged_in?
      !!logged_in_user
    end
  
    def authorized
      render json: { message: 'Please log in', token: @auth_header }, status: :unauthorized unless logged_in?
    end
end