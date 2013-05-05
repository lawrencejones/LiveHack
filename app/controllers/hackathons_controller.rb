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
    @hackathon = Hackathon.find_by_eid(params[:id])
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
    end
    hack[:users].each do |i,usr|
      @user = User.find_by_username(usr[:id])
      if @user.blank?
        @hackathon.users.create(:name => usr[:name], :username => usr[:id])
      else
        @user.hackathons << @hackathon
      end
    end
    unless hack[:schedule_items].nil?
      hack[:schedule_items].each_pair do |i,itm|
        @item = @hackathon.schedule_items.create(
          :label => itm[:label], :icon_class => itm[:icon_class], :start_time => itm[:start])
      end
    end
    render json: {status: :created}
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

  def schedule_items
    @hack = Hackathon.find_by_eid params[:eid]
    render json: { :schedule => @hack.schedule_items.all }
  end

  # GET /subscribed_to/username
  # PRE : receives params which is an hash containing
  #       username : username
  #       eids : { 1 => 'eid', ..., n => 'eid' }
  def subscribed_to
    needs_update = false
    if !params[:eids].nil?
      params[:eids].each do |eid|
        @hackathon = Hackathon.find_by_eid(eid)
        if !@hackathon.blank?
          @user = @hackathon.users.find_by_username params[:username]
          if @user.blank?
            needs_update = true
            @hackathon.users << User.find_by_username(params[:username])
          end
        end
      end
    end
    render :partial => 'hackathon_table', :locals => {:needs_update => needs_update}
  end

  # POST /update_users
  # PRE : params contains an array of events
  #       params = { events => [eid => users]}
  #       where users = [(name => name, username => username), ...]
  def update_users
    events = params[:events]
    if events
      events.each do |i,event|
        @hackathon = Hackathon.find_by_eid event[:name]
        if !@hackathon.blank?
          event[:fql_result_set].each do |i,usr|
            @user = User.find_by_username usr[:uid]
            if @user.blank?
              @hackathon.users << User.create(:username => usr[:uid],
               :name => usr[:name])
            elsif @user.hackathons.find_by_eid(@hackathon.eid).blank?
              @hackathon.users << @user
            end
          end
        end
      end
    end
    respond_to do |format|
      format.json {render json: {:status => :'Events updated'}}
    end
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
