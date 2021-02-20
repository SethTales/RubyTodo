class UsersController < ApplicationController
  skip_before_action :validate_token#, :only => [:user, :create, :login, :authenticate]

  def user
  end

  def create
    username = params[:user][:email]
    password = params[:user][:password]
    users_repo = UsersRepository.new();
    
    if users_repo.user_exists(params[:user][:email])
      flash[:notice] = "User already exists, please login."
      redirect_to "/users/login" and return
    end
    auth_service = AuthService.new()
    salt = auth_service.get_salt
    hashed_and_salted_pass = auth_service.get_hashed_and_salted_pass(password, salt)
    created = users_repo.create_user(username, hashed_and_salted_pass, salt)
    if !created.valid?
      flash[:notice] = "Error creating user, please try again."
      redirect_to "/users/create" and return
    else
      flash[:notice] = "Account created, please login."
      redirect_to "/users/login" and return
    end
  end

  def login
  end

  def authenticate
    username = params[:user][:email]
    password = params[:user][:password]
    users_repo = UsersRepository.new();
    
    if !users_repo.user_exists(username)
      flash[:notice] = "User does not exist, please sign up."
      redirect_to "/users/create" and return
    end
    
    user = users_repo.get_user(username)
    auth_service = AuthService.new()
    hashed_and_salted_pass = auth_service.get_hashed_and_salted_pass(password, user.salt)
    
    if !auth_service.validate_password(user.password, hashed_and_salted_pass)
      flash[:notice] = "Incorrect user name or password."
      redirect_to "/users/login" and return
    end

    token = auth_service.get_token(user.id)
    cookies["token"] = { :value => token, :httponly => true } 

    redirect_to "/todo/#{user.id}"
  end
end
