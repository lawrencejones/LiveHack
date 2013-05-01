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
      format.html # show.html.erb
      format.json { render json: @hackathon.users }
    end
  end

  # GET /hackathons/new
  # GET /hackathons/new.json
  def new
    @hackathon = Hackathon.new

    respond_to do |format|
      format.html { render :partial => 'new_hack_modal'}
      format.json { render json: @hackathon }
    end
  end

  # GET /hackathons/1/edit
  def edit
    @hackathon = Hackathon.find(params[:id])
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
        @user = @hackathon.users.create(:name => usr[:name], :username => usr[:id])
      end
      hack[:schedule_items].each_pair do |i,itm|
        @item = @hackathon.schedule_items.create(:label => itm[:label], :start_time => itm[:start])
      end
      render json: @hackathon, status: :created, location: @hackathon
    else
      puts "Did not add"
      render json: {:status => :Failed, :message => :"Already present"}
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
