class GitDataController < ApplicationController
  # GET /git_data
  # GET /git_data.json
  def index
    @git_data = GitDatum.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @git_data }
    end
  end

  # GET /git_data/1
  # GET /git_data/1.json
  def show
    @git_datum = GitDatum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @git_datum }
    end
  end

  # GET /git_data/new
  # GET /git_data/new.json
  def new
    @git_datum = GitDatum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @git_datum }
    end
  end

  # GET /git_data/1/edit
  def edit
    @git_datum = GitDatum.find(params[:id])
  end

  # POST /git_data
  # POST /git_data.json
  def create
    @git_datum = GitDatum.new(params[:git_datum])

    respond_to do |format|
      if @git_datum.save
        format.html { redirect_to @git_datum, notice: 'Git datum was successfully created.' }
        format.json { render json: @git_datum, status: :created, location: @git_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @git_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /git_data/1
  # PUT /git_data/1.json
  def update
    @git_datum = GitDatum.find(params[:id])

    respond_to do |format|
      if @git_datum.update_attributes(params[:git_datum])
        format.html { redirect_to @git_datum, notice: 'Git datum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @git_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /git_data/1
  # DELETE /git_data/1.json
  def destroy
    @git_datum = GitDatum.find(params[:id])
    @git_datum.destroy

    respond_to do |format|
      format.html { redirect_to git_data_url }
      format.json { head :no_content }
    end
  end
end
