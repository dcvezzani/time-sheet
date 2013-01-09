class TimeSheetEntriesController < ApplicationController
  # GET /time_sheet_entries
  # GET /time_sheet_entries.json
  def index
    @time_sheet_entries = TimeSheetEntry.all
    @topics = Topic.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @time_sheet_entries }
    end
  end

  # GET /time_sheet_entries/1
  # GET /time_sheet_entries/1.json
  def show
    @time_sheet_entry = TimeSheetEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @time_sheet_entry }
    end
  end

  # GET /time_sheet_entries/new
  # GET /time_sheet_entries/new.json
  def new
    @time_sheet_entry = TimeSheetEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @time_sheet_entry }
    end
  end

  # GET /time_sheet_entries/1/edit
  def edit
    @time_sheet_entry = TimeSheetEntry.find(params[:id])
  end

  # POST /time_sheet_entries
  # POST /time_sheet_entries.json
  def create
    @time_sheet_entry = TimeSheetEntry.new(params[:time_sheet_entry])

    respond_to do |format|
      if @time_sheet_entry.save
        format.html { redirect_to @time_sheet_entry, notice: 'Time sheet entry was successfully created.' }
        format.json { render json: @time_sheet_entry, status: :created, location: @time_sheet_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @time_sheet_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /time_sheet_entries/1
  # PUT /time_sheet_entries/1.json
  def update
    @time_sheet_entry = TimeSheetEntry.find(params[:id])

    respond_to do |format|
      if @time_sheet_entry.update_attributes(params[:time_sheet_entry])
        format.html { redirect_to @time_sheet_entry, notice: 'Time sheet entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @time_sheet_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_sheet_entries/1
  # DELETE /time_sheet_entries/1.json
  def destroy
    @time_sheet_entry = TimeSheetEntry.find(params[:id])
    @time_sheet_entry.destroy

    respond_to do |format|
      format.html { redirect_to time_sheet_entries_url }
      format.json { head :no_content }
    end
  end
end
