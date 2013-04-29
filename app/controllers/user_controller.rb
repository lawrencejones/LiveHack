class UserController < ApplicationController
	
	def create
		@user = User.new(params[:user])
		render json: @user, status: :created, location: @user
	end

	def index
    @users = User.all
    @user = User.new

    respond_to do |format|
      format.json { render json: @hackathons }
    end
  end

	def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

end
