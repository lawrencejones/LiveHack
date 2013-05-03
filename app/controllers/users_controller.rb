class UsersController < ApplicationController
	
	# POST /users.json
	def create
		@user = User.find_by_username params[:user][:username]
    puts 'Giving data'
    if params[:giving_details]
      puts 'Giving data'
      @user[:github_email] = params[:user][:github_email]
      @user[:tags] = params[:user][:tags]
      @user[:signed_up] = true
      if @user.save
        render json: @user
      end
    else
      # query db for the posted user
  		if @user.blank?
        # if user never existed, then create them
  			@user = User.create params[:user]
      elsif !@user[:signed_up]
        # if the user already exists, just hasn't yet logged in
        # then absorb email
        @user[:email] = params[:user][:email]
      end
      respond_to do |format|
        if !@user[:signed_up]
          # if we don't have extended details then ask for
          # them using json message
          format.json {render json: @user, :message => :requires_details}
        else
          # else just send back the user
          format.json {render json: @user}
        end
      end
    end
	end


  def update
    @user = User.find_by_username params[:user][:username]
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
