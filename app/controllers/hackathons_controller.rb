class HackathonsController < ApplicationController
  # GET /hackathons
  # GET /hackathons.json
  def index
    @hackathons = Hackathon.all
    @hackathon = Hackathon.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hackathons }
    end
  end

  # GET /hackathons/1
  # GET /hackathons/1.json
  def show
    @hackathon = Hackathon.find(params[:id])
    respond_to do |format|
      format.html { render :hackathon_body, :layout => false }
      format.json { render json: @hackathon }
    end
  end

  # POST /hackathons
  # POST /hackathons.json
  def create
    hack = params[:hackathon]
    @hackathon = Hackathon.find_by_eid hack[:eid]
    if @hackathon.blank?
      @hackathon = Hackathon.create(:eid => hack[:eid], 
        :name => hack[:name], :description => hack[:description],
        :location => hack[:location], :start => hack[:start_time], :end => hack[:end_time])
      hack[:users].each_pair do |i,usr|
        @user = User.find_by_username(usr[:id])
        if @user.blank?
          @user = @hackathon.users.create(:name => usr[:name], :username => usr[:id])
          puts @user.name
        end
        @user.hackathons << @hackathon
      end
      unless hack[:schedule_items].nil?
        hack[:schedule_items].each_pair do |i,itm|
          @item = @hackathon.schedule_items.create(:label => itm[:label], :start_time => itm[:start])
        end
      end
      render json: @hackathon, status: :created, location: @hackathon
    else
      puts "Did not add"
      render json: {:status => :failed, :message => :"Already present"}
    end
  end

  # POST /update_hackathons_users
  def update_hackathons_users
    added_users = Array.new
    params[:hackathons].each do |i,data|
      @hackathon = Hackathon.find_by_eid(data[:name])
      if !@hackathon.blank?
        data[:fql_result_set].each do |i,usr|
          @user = @hackathon.users.find_by_username(usr[:username])
          if @user.blank?
            @user = @hackathon.users.create(:name => usr[:name], :username => usr[:id])
            puts @user.name
            added_users << @user
          end
        end
      end
    end
    respond_to do |format|
      if added_users.size == 0
        format.json {render json: {:status => :'None added?'}}
      else
        format.json {render json: {:status => :'Added users', :users => added_users}}
      end
    end
  end


  # POST /hackathons/get_hackathons_to_update.json
  # return hackathons that need userlist updates
  def get_hackathons_to_update
    added_hack = false
    result = Array.new
    params[:eids].each do |eid|
      @hackathon = Hackathon.find_by_eid(eid)
      if !@hackathon.blank?
        @check = @hackathon.users.find_by_username(params[:username])
        if @check.blank?
          added_hack = true
          result.push @hackathon[:eid]
        end
      end
    end
    respond_to do |format|
      if added_hack
        format.json { render json: @result }
      else
        format.json { render json: {:status => :'None added'}}
      end
    end
  end

  def new
    respond_to do |format|
      format.html {render :partial => 'new_hack_modal'}
    end
  end

  # POST /hackathons/exists.json
  def exists
    if Hackathon.find_by_eid(params[:eid]).blank?
      render json: {:status => :fine}
    else
      render json: {:status => :stop}
    end
  end


  # PUT /hackathons/1
  # PUT /hackathons/1.json
  def update
    @hackathon = Hackathon.new(params[:hackathon])

    respond_to do |format|
      if @hackathon.update_attributes(params[:hackathon])
        format.html { redirect_to @hackathon, notice: 'Hackathon was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hackathon.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /subscribed_to/username
  def subscribed_to 
    render :partial => 'hackathon_table'
  end

  # DELETE /hackathons/1
  # DELETE /hackathons/1.json
  def destroy
    @hackathon = Hackathon.find(params[:id])
    @hackathon.destroy

    respond_to do |format|
      format.html { redirect_to hackathons_url }
      format.json { head :no_content }
    end
  end

  def delete_all
    Hackathon.delete_all
    render :nothing => true
  end
  
end
