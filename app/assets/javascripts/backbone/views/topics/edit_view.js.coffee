TimeSheet.Views.Topics ||= {}

class TimeSheet.Views.Topics.EditView extends Backbone.View
  template: JST["backbone/templates/topics/edit"]

  events:
    "submit #edit-topic": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (topic) =>
        @model = topic
        #window.location.hash = "/#{@model.id}"
        #window.location.hash = "/index"
        window.router.index()
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    setTimeout(->
      $("input[name='name']").focus()
    50)

    return this
