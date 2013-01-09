TimeSheet.Views.TimeSheetEntries ||= {}

class TimeSheet.Views.TimeSheetEntries.TimeSheetEntryView extends Backbone.View
  template: JST["backbone/templates/time_sheet_entries/time_sheet_entry"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"
  className: "data"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
