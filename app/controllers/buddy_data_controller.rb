class BuddyDataController < ApplicationController
  # GET /buddy_data
  # GET /buddy_data.json
  def index
    @buddy_data = BuddyDatum.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @buddy_data }
    end
  end

  # GET /buddy_data/1
  # GET /buddy_data/1.json
  def show
    @buddy_datum = BuddyDatum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @buddy_datum }
    end
  end

  # GET /buddy_data/new
  # GET /buddy_data/new.json
  def new
    @buddy_datum = BuddyDatum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @buddy_datum }
    end
  end

  # GET /buddy_data/1/edit
  def edit
    @buddy_datum = BuddyDatum.find(params[:id])
  end

  # POST /buddy_data
  # POST /buddy_data.json
  def create
    @buddy_datum = BuddyDatum.new(params[:buddy_datum])

    respond_to do |format|
      if @buddy_datum.save
        format.html { redirect_to @buddy_datum, notice: 'Buddy datum was successfully created.' }
        format.json { render json: @buddy_datum, status: :created, location: @buddy_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @buddy_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /buddy_data/1
  # PUT /buddy_data/1.json
  def update
    @buddy_datum = BuddyDatum.find(params[:id])

    respond_to do |format|
      if @buddy_datum.update_attributes(params[:buddy_datum])
        format.html { redirect_to @buddy_datum, notice: 'Buddy datum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @buddy_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buddy_data/1
  # DELETE /buddy_data/1.json
  def destroy
    @buddy_datum = BuddyDatum.find(params[:id])
    @buddy_datum.destroy

    respond_to do |format|
      format.html { redirect_to buddy_data_url }
      format.json { head :no_content }
    end
  end
end
