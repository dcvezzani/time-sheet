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
        #this.refreshCollectionAndRenderFor(window.router, "topics", '/index')

      error: (topic, jqXHR) =>
        self.renderHtml(form, jqXHR.responseText)
    )

  updateOrig: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (topic) =>
        @model = topic
        #window.location.hash = "/#{@model.id}"
        window.location.hash = "/index"
    )

  renderOrig: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    setTimeout(->
      $("input[name='name']").focus()
    50)

    return this

  render: ->
    self = this
    @template(@model.toJSON(), (data) -> 
      self.$el.html(data)
      self.$("form").backboneLink(self.model)

      setTimeout(->
        $("input[name='name']").focus()
      50)
    )

    return self
