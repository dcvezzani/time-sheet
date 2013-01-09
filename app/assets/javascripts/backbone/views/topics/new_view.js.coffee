TimeSheet.Views.Topics ||= {}

class TimeSheet.Views.Topics.NewView extends Backbone.View
  #template: JST["backbone/templates/topics/new"]
  template: (model, callback) -> _.template(
    #href = $("#edit-topic-from-erb").attr("href").replace(/__xxx__/, model.id)
    href = $("#new-topic-from-erb").attr("href")
    console.log("new href: " + href)
    
    $.get(href, (data) ->
      callback(data)
    )
  )

  events:
    "submit #new_topic": "save"

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
        #this.refreshCollectionAndRenderFor(window.router, "topics", '/index')

      error: (topic, jqXHR) =>
        self.renderHtml(form, jqXHR.responseText)
    )

  saveOrig: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (topic) =>
        @model = topic
        #window.location.hash = "/#{@model.id}"
        window.location.hash = "/index"

      error: (topic, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
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
