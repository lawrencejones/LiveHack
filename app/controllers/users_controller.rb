class UsersController < ApplicationController
	
	# POST /users.json
	def create
		@user = User.find_by_username params[:user][:username]
		if @user.blank?
			@user = User.new params[:user]
			
			if @user.save
				render json: @user
			else
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		else
  		render json: @user
    end
	end

	# GET /users.json
	def index
    @users = User.all
    @user = User.new

    respond_to do |format|
      format.json { render json: @users }
    end
  end

  # GET /users/new
	def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/:id.json
  def show
  	@user = User.find(params[:id])
  	respond_to do |format|
  		format.json {render :json => @user }
  	end
  end

  # GET /users/delete_all
  def delete_all
  	User.delete_all
  	render :nothing => true
  end

end
