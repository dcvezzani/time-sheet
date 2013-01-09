TimeSheet.Views.TimeSheetEntries ||= {}

class TimeSheet.Views.TimeSheetEntries.IndexView extends Backbone.View
  template: JST["backbone/templates/time_sheet_entries/index"]

  initialize: () ->
    @options.time_sheet_entries.bind('reset', @addAll)

  addAll: () =>
    @options.time_sheet_entries.each(@addOne)

  addOne: (timeSheetEntry) =>
    view = new TimeSheet.Views.TimeSheetEntries.TimeSheetEntryView({model : timeSheetEntry})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(time_sheet_entries: @options.time_sheet_entries.toJSON() ))
    @addAll()

    return this
