TimeSheet.Views.TimeSheetEntries ||= {}

class TimeSheet.Views.TimeSheetEntries.ShowView extends Backbone.View
  template: JST["backbone/templates/time_sheet_entries/show"]

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
