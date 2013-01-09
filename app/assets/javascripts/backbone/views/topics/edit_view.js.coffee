TimeSheet.Views.Topics ||= {}

class TimeSheet.Views.Topics.EditView extends Backbone.View
  #template: JST["backbone/templates/topics/edit"]
  template: (model, callback) -> _.template(
    href = $("#edit-topic-from-erb").attr("href").replace(/__xxx__/, model.id)
    console.log("edit href: " + href)
    
    $.get(href, (data) ->
      callback(data)
    )
  )

  events:
    "submit .edit-topic": "update"

  update: (e) ->
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
