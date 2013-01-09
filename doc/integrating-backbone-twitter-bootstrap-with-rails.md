### Create or select a Rails application

Create project and update local configuration.  Also, update 'application' name for configuration files (a manual process).

I use ```clean-start``` as a base for many of my projects.  There are some tasks that I run manually; I open them in vim and
then copy/paste them in terminal to generate local files and set up my database.

```
git clone -b master clean-start time-sheet
cd time-sheet

vim -p ./build-local-database.txt ./build-local-start-scripts.txt
```

Update bundle and run migrations.

Update your Gemfile, create the binstubs (<rails-root>/bin) if they don't already exist 
and make sure you're caught up with your migrations.

```
bundle update
bundle install --binstubs

./bin/rake db:migrate db:migrate:status
```

Test out basics.

The 'basics' includes RSpec (including steak), Watchr listener with Spork to speed up tests, 
starting the application and opening the home page in your system's web browser.

```
./bin/rspec

./spork
./watchr.sh

./start.sh
./open.sh
```


### Scaffold out the resource

For both Rails and Backbone.

It's not necessary, but since this is a study, I create 2 additional sets of resources to clarify 
the difference between using the original Rails-generated scaffolding and the Backbone-integrated
resource.

```
./bin/rails g scaffold Topic name:string description:text

./bin/rails g backbone:install
./bin/rails g backbone:scaffold Topic name:string description:text
```

I.e., config/routes.rb

```
resources :topics, controller: :topics_bb
resources :topics_orig, controller: :topics
resources :topics_bb, controller: :topics_bb
```


### Create controller for Backbone-integrated resource

Assuming that you create the resource named 'topic', this controller should inherit from 
the Rails-generated one.

The ```html``` format is for rendering the initial ```index``` page.  The ```json``` format is used by Backbone to retrieve collections of models.

E.g., app/controllers/topics_bb_controller.rb

```
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
```

Save off a copy of the originally scaffold-generated index page.

```
cp app/view/topics/index.html.rb app/view/topics/index_original.html.rb
```

Bootstrap Backbone to the index view.  Include support for shortcut key to create a new item 
(only activates when index landing zone (lz) exists; e.g., '#topics-table').

E.g., app/view/topics/index_backbone.html.erb

```
<style type="text/css">
  table th.name{
    width: 300px;
  }
  table td.name{
    vertical-align: top;
  }
</style>

<div id="topics"></div>

<script type="text/javascript">
  $(function() {
    // TimeSheet is the app name
    window.router = new TimeSheet.Routers.TopicsRouter({topics: <%= @topics.to_json.html_safe -%>});
    Backbone.history.start();

    $(document).keyup(function(e){
      if($("#topics-table").length > 0){
        switch(e.keyCode){
          case 78:
            //console.log("load new form")
            window.router.navigate("/new", {trigger: true});
            break;
          default:
        }
        //console.log(e.type, e.keyCode)
      }
    })
  });
</script>
```

Set the default index page to use Backbone flavored view.

```
cp app/view/topics/index_backbone.html.rb app/view/topics/index.html.rb
```

### Update Backbone model

Include configuration to exclude Rails model attributes that are not attr_accessible.  
Point base url to desired controller.

E.g., app/assets/javascripts/backbone/models/topic.js.coffee

```
  paramRoot: 'topic'

  ...

  secureAttributes: [
    'created_at', 'updated_at'
  ]

  toJSON: ->
    @_cloneAttributes();

  _cloneAttributes: ->
    attributes = _.clone(@attributes)
    for sa in @secureAttributes
      delete attributes[sa]
    _.clone(attributes)

  ...

  url: '/topics_bb'
```

### Update item view

Distinguish 'data' td cells and add confirmation for delete.

E.g., app/assets/javascripts/backbone/views/topics/topic_view.js.coffee

```
  tagName: "tr"
  className: "data"
  ...

  destroy: () ->
    if(confirm("Are you sure?"))
      @model.destroy()
      this.remove()
```


### Update index template

Update index template to use Twitter Bootstrap design elements.  Reduce the number of empty 'action' th tags to one.

E.g., app/assets/javascripts/backbone/templates/topics/index.js.ejs

```
<div class="well well-outline">
  <div class="page-header">
  <h1>Listing topics <small></small></h1>
  </div>

  <table id="topics-table" class="table table-striped">
    <tr>
      <th class="name">Name</th>
      <th>Description</th>
      <th></th>
    </tr>
  </table>

  <br/>

  <a href="#/new" class="btn btn-primary">New Topic</a>
</div>
``` 

Update item template to use Twitter Bootstrap design elements.  Use icons to represent actions.

E.g., app/assets/javascripts/backbone/templates/topics/topic.js.ejs

```
<td><%= name %></td>
<td><%= description %></td>

<td>
  <div class="control-group">
    <div class="btn-group pull-right">
      <a class="btn" href="#/<%= id %>" title="Show"> <i class="icon-search"></i> <span class="hidden">Show</span> </a>
      <a class="btn edit-spouse-<%= id %>" href="#/<%= id %>/edit" title="Edit"> <i class="icon-pencil"></i> <span class="hidden">Edit</span> </a>
      <a class="btn destroy" href="#/<%= id %>/destroy" title="Destroy"> <i class="icon-trash"></i> <span class="hidden">Destroy</span></a>
    </div>
  </div>
</td>
```

### Update new view

Update to return back to the index view (instead of the show view).  Put the focus on the first field in the form.

E.g., app/assets/javascripts/backbone/views/topics/new_view.js.coffee

```
  save: (e) ->
  ...
        #window.location.hash = "/#{@model.id}"
        window.location.hash = "/index"
  ...
  render: ->
    ...
    setTimeout(->
      $("input[name='name']").focus()
    50)
```

Update in much the same way as the 'new view', only the method is ```update``` here instead of ```save```.

E.g., app/assets/javascripts/backbone/views/topics/edit_view.js.coffee

```
  update: (e) ->
  ...
        #window.location.hash = "/#{@model.id}"
        window.location.hash = "/index"
  ...
  render: ->
    ...
    setTimeout(->
      $("input[name='name']").focus()
    50)
```

### Use the Rails ERB view files

#### Keeping things clean and DRY

##### A few Backbone extensions

We will create a simple JS library where we can keep some common functionality handy, especially for our 'new' and 'edit' Backbone views.
It includes the following methods:

1. **Backbone.View#postViaHtml**: Post data create/update through html requests to the Rails controller. 
This is used instead of making JSON requests which would be typical for a Backbone view.  
The input, so as to speak, is 'html' and 'html' is returned.

2. **Backbone.Router#refreshCollectionAndRenderFor**: Pull an updated list of JSON objects from the server.  Then render using the specified Backbone route.
A JSON request is made to get a refreshed collection of models.  The Backbone router is used to navigate to route (e.g., '/index').

3. **Backbone.View.renderContent**: Common module for rendering html returned from the controller from an 'html' request.
This 'instance method' is used as the given view's ```#render()``` method.  It should be used only for views that rely on
Rails ERB files instead of Backbone templates (e.g., 'new_view', 'edit_view').

4. **Backbone.View#afterRender**: Post-processing that may take place after #render() is called.
E.g., focus on a field element and select the text.

These methods are packaged in a little Backbone extension library included in this sample app.


##### Rails ERB view helpers

Well, there's actually only one pertinent to this current example.  Provide an easy way to identify
Rails scaffold-generated forms.

Using a generic reference:

```
.new-form, .edit-form
```

Using a more specific reference (assuming your resource name is 'topic'):
```
.new-topic, .edit-topic
```

E.g., app/helpers/application_helper.rb

```
module ApplicationHelper
  ...
  def form_type(obj)
    if(obj.new_record?)
      "new-form new-#{obj.class.name.downcase}"
    else
      "edit-form edit-#{obj.class.name.downcase}"
    end
  end
  ...
end
```

#### Integrate the 'new' action

To use the Rails ERB view files, we configure the ```template``` method to go fetch html through the controller instead of using Backbone's templates.
This enables us to use the Rails view helpers including rendering errors.  This means we need to make some calls manually that would otherwise
be automatic, such as updating the collection of models.  By fetching the collection again, we should be able to see the new entry that was
just created.  In order for post processing to take place after the DOM has been retrieved, we supply a callback to the ```template``` method.

Update the id for the form, as it is slightly different in the scaffold-generated ```_form.html.erb```.

E.g., app/assets/javascripts/backbone/views/topics/new_view.js.coffee

```
class TimeSheet.Views.Topics.NewView extends Backbone.View
  template: (model, callback) -> _.template(
    href = $("#new-topic-from-erb").attr("href")
    console.log("new href: " + href)
    
    $.get(href, (data) ->
      callback(data)
    )
  )

  events:
    "submit .new-topic": "save"

  ...

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    form = $(e.target)
    @model.unset("errors")

    @postViaHtml(form, 
      success: (topic) =>
        window.router.refreshCollectionAndRenderFor("topics", '/index')

      error: (jqXHR, status) =>
        @renderHtml(jqXHR.responseText)
    )

  ###
  afterRender: ->
    $("#topic_name").focus().select()
  ###

  render: Backbone.View.renderContent
```

Next we need to tweak the ```Back``` link so that it includes the necessary anchor for Backbone.

E.g., app/views/topics/new.html.erb

```
<%= link_to 'Back', topics_path(anchor: "/index") %>
```

Now we start applying Twitter Bootstrap design elements to our Rails view.

E.g., app/views/topics/new.html.erb

```
<div class="well">
  <div class="page-header">
  <h1>New topic <small></small></h1>
  </div>

  <%= render 'form' %>

  <%= link_to 'Back', topics_path(anchor: "/index") %>
</div>
```

And we continue sprucing up the form itself.  In order to use a horizontal alignment for the form using Twitter Bootstrap, we apply classes
to the ```form``` and ```label``` and then wrap each label/input combination and input in their own ```div``` tags.  The button should also
be styled as the primary button.

E.g., app/views/topics/_form.html.erb

```
<%= form_for(@topic, html: {class: "form form-horizontal #{form_type(@topic)}"}) do |f| %>
...
  <div class="field control-group">
    <%= f.label :name, class: "control-label" %>
    <div class="controls">
      <%= f.text_field :name %>
    </div>
  </div>
  <div class="field control-group">
    <%= f.label :description, class: "control-label" %>
    <div class="controls">
      <%= f.text_area :description %>
    </div>
  </div>
  <div class="actions">
    <%= f.submit nil, class: "btn btn-primary" %>
  </div>
<% end %>

```

##### Create actions for Backbone-integrated resource

The controller should be adjusted so that when the ```create``` action is called, no redirect will be sent.
Otherwise, the client is making an additional call for the redirect that will never be used.

E.g., app/controllers/topics_bb_controller.rb

```
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
        format.html { render action: "new", layout: false }
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
        format.html { render action: "edit", layout: false }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

```

#### Integrate the 'edit' action

Go through a similar process for edit.  There will be slight differences as noted below.

E.g., app/assets/javascripts/backbone/views/topics/edit_view.js.coffee

```
  template: (model, callback) -> _.template(
    href = $("#edit-topic-from-erb").attr("href").replace(/__xxx__/, model.id)
    console.log("edit href: " + href)
    
    ...
  )

  events:
    "submit .edit-topic": "update"

  ...
  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    form = $(e.target)
    @model.unset("errors")

    @postViaHtml(form, 
      success: (topic) =>
        window.router.refreshCollectionAndRenderFor("topics", '/index')

      error: (topic, jqXHR) =>
        self.renderHtml(form, jqXHR.responseText)
    )
```

Again, ```edit.html.erb``` will be similarly structured to ```new.html.erb```, but with 
an additional change to conform with the Backbone router syntax for the 'show' action.

E.g., app/views/topics/new.html.erb

```
  <%= link_to 'Show', "#/#{@topic.id}" %>
```

##### Clean up 'template' links

Hide the 'template' links.

E.g., app/views/topics/index_backbone.html.erb

```
<%= link_to "New Topic (from ERB) Template", new_topic_path, id: "new-topic-from-erb", style: "display: none;" %>
<%= link_to "Edit Topic (from ERB) Template", edit_topic_path("__xxx__"), id: "edit-topic-from-erb", style: "display: none;" %>
```

#### Update the 'show' template

Apply Twitter Bootstrap design elements to the ```show``` template.  There is no need in this instance to be using the Rails generated view.

E.g., app/assets/javascripts/backbone/templates/topics/show.jst.ejs

```
<div class="well well-outline">
  <div class="page-header">
  <h1>Show topic <small></small></h1>
  </div>

  <div class="topic-details">
    <p>
      <b>Name:</b>
      <%= name %>
    </p>

    <p>
      <b>Description:</b>
      <%= description %>
    </p>
  </div>

  <a href="#/<%= id %>/edit">Edit</a>
  <a href="#/index">Back</a>
</div>
```

#### Update item view (for the 'delete' action)

If you wish to prompt the end user for confirmation before deleting, add the ```confirm()``` check.  
There is no need in this instance to be using the Rails generated view.

E.g., app/assets/javascripts/backbone/views/topics/topic_view.js.coffee

```
  destroy: () ->
    if(confirm("Are you sure?"))
      @model.destroy()
      this.remove()
```

### Add additional key shortcuts for convenience

E.g., app/views/topics/index_backbone.html.erb

```
<script type="text/javascript">
  $(function() {
    // TimeSheet is the app name
    window.router = new TimeSheet.Routers.TopicsRouter({topics: <%= @topics.to_json.html_safe -%>});
    Backbone.history.start();

    $(document).keyup(function(e){
      if($("#topics-table").length > 0){
        switch(e.keyCode){
          case 78: # 'n'
            window.router.navigate("/new", {trigger: true});
            break;
          default:
        }
      }

      if($(".topic-details").length > 0){
        switch(e.keyCode){
          case 66: # 'b'
            window.router.navigate("/index", {trigger: true});
            break;
          default:
        }
      }

      //console.log(e.type, e.keyCode)
    })
  });
</script>
```

### But wait,... I'm not seeing the errors!

Rails returns a successful response (in terms of HTTP return codes) always, even when validation fails. 
In order for an ajax call to register error logic handling, we need an error code.

E.g., app/controllers/topics_bb_controller.rb, #create

```
    respond_to do |format|
      if @topic.save
        ...
      else
        format.html { render action: "new", layout: false, status: :unprocessable_entity }
        ...
      end
    end
```

E.g., app/controllers/topics_bb_controller.rb, #update

```
    respond_to do |format|
      if false and @topic.update_attributes(params[:topic])
        ...
      else
        format.html { render action: "edit", layout: false, status: :unprocessable_entity }
        ...
      end
    end
```

### Conclusion

Backbone is a fabulous resource for organizing JavaScript intensive web applications.  It can do a lot.  
Sometimes, we don't need a lot, but want to benefit from the framework that Backbone has to offer.  In this example, 
we wanted to leverage some of the Rails-generated views, helpers and validation.  We accomplish this by adhering to
the following high-level concepts:

1. To leverage Rails ERB generated 'new' and 'edit' views, including the display of errors, partials (especially _form.html.erb), 
and helpers, we make 'html' requests of the controller and expect 'html' responses that we simply render the html we received rather 
than generate the HTML using the associated collection of JSON objects and Backbone templates.

2. In most cases, we can simply continue using Backbone's templates for the other actions, so those Backbone views will largely
be left unaltered.


I'm not completely sure what repurcussions there are to this approach, but so far, it's working fine.  Sure, this approach could be seen as
defeating some of the goals and aims of Backbone, but I feel that sometimes you try to use the best of both worlds to
achieve an end goal.

