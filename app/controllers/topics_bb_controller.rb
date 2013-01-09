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
end
