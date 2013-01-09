class TopicsBbController < TopicsController

  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.all

    respond_to do |format|
      format.html {render 'index_backbone'}
      format.json { render json: @topics }
    end
  end

  # GET /topics/new
  # GET /topics/new.json
  def new
    @topic = Topic.new

    respond_to do |format|
      format.html { render layout: false } # new.html.erb
      format.json { render json: @topic }
    end
  end
  
  # GET /topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
    render layout: false
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(params[:topic])

    respond_to do |format|
      if @topic.save
        format.html { render text: "ok" }
        format.json { render json: @topic, status: :created, location: @topic }
      else
        format.html { render action: "new", layout: false, status: :unprocessable_entity }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.json
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { render text: "ok" }
        format.json { head :no_content }
      else
        format.html { render action: "edit", layout: false, status: :unprocessable_entity }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

end
