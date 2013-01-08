class TopicsBbController < TopicsController
  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.all
    render 'index_backbone'
  end
end
