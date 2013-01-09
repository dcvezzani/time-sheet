TimeSheet.Views.Topics ||= {}

class TimeSheet.Views.Topics.TopicView extends Backbone.View
  template: JST["backbone/templates/topics/topic"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"
  className: "data"

  destroy: () ->
    #if(confirm("Are you sure?"))
    @model.destroy()
    this.remove()

    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
