class TimeSheetEntriesBbController < TimeSheetEntriesController
  def time_sheet_and_topic_entries
    @time_sheet_entries = TimeSheetEntry.all
    @topics = Topic.all

    render 'index_with_topics'
  end

  # GET /topics/new
  # GET /topics/new.json
  def new
    @time_sheet_entry = TimeSheetEntry.new

    respond_to do |format|
      format.html { render layout: false } # new.html.erb
      format.json { render json: @time_sheet_entry }
    end
  end

  # GET /topics/1/edit
  def edit
    @time_sheet_entry = TimeSheetEntry.find(params[:id])
    render layout: false
  end

  # POST /topics
  # POST /topics.json
  def create
    @time_sheet_entry = TimeSheetEntry.new(params[:time_sheet_entry])

    respond_to do |format|
      if @time_sheet_entry.save
        format.html { render text: "ok" }
        format.json { render json: @time_sheet_entry, status: :created, location: @time_sheet_entry }
      else
        format.html { render action: "new", layout: false, status: :unprocessable_entity }
        format.json { render json: @time_sheet_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.json
  def update
    @time_sheet_entry = TimeSheetEntry.find(params[:id])

    respond_to do |format|
      if @time_sheet_entry.update_attributes(params[:time_sheet_entry])
        format.html { render text: "ok" }
        format.json { head :no_content }
      else
        format.html { render action: "edit", layout: false, status: :unprocessable_entity }
        format.json { render json: @time_sheet_entry.errors, status: :unprocessable_entity }
      end
    end
  end
end
