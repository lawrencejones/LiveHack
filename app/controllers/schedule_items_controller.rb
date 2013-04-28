class ScheduleItemsController < ApplicationController
  # GET /schedule_items
  # GET /schedule_items.json
  def index
    @schedule_items = ScheduleItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @schedule_items }
    end
  end

  # GET /schedule_items/1
  # GET /schedule_items/1.json
  def show
    @schedule_item = ScheduleItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @schedule_item }
    end
  end

  # GET /schedule_items/new
  # GET /schedule_items/new.json
  def new
    @schedule_item = ScheduleItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @schedule_item }
    end
  end

  # GET /schedule_items/1/edit
  def edit
    @schedule_item = ScheduleItem.find(params[:id])
  end

  # POST /schedule_items
  # POST /schedule_items.json
  def create
    @schedule_item = ScheduleItem.new(params[:schedule_item])

    respond_to do |format|
      if @schedule_item.save
        format.html { redirect_to @schedule_item, notice: 'Schedule item was successfully created.' }
        format.json { render json: @schedule_item, status: :created, location: @schedule_item }
      else
        format.html { render action: "new" }
        format.json { render json: @schedule_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /schedule_items/1
  # PUT /schedule_items/1.json
  def update
    @schedule_item = ScheduleItem.find(params[:id])

    respond_to do |format|
      if @schedule_item.update_attributes(params[:schedule_item])
        format.html { redirect_to @schedule_item, notice: 'Schedule item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @schedule_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schedule_items/1
  # DELETE /schedule_items/1.json
  def destroy
    @schedule_item = ScheduleItem.find(params[:id])
    @schedule_item.destroy

    respond_to do |format|
      format.html { redirect_to schedule_items_url }
      format.json { head :no_content }
    end
  end
end
