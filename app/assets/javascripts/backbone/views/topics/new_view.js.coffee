TimeSheet.Views.Topics ||= {}

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

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    form = $(e.target)
    @model.unset("errors")

    @postViaHtml(form, 
      success: (topic) =>
        window.router.refreshCollectionAndRenderFor("topics", '/index')

      error: (jqXHR, status) =>
        @render(jqXHR.responseText)
    )

  ###
  afterRender: ->
    $("#topic_name").focus().select()
  ###

  render: Backbone.View.renderContent

