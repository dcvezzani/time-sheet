class TimeSheet.Routers.TimeSheetEntriesRouter extends Backbone.Router
  initialize: (options) ->
    @time_sheet_entries = new TimeSheet.Collections.TimeSheetEntriesCollection()
    @time_sheet_entries.reset options.time_sheet_entries
    @new_url = options.new_url
    @edit_url = options.edit_url

  routes:
    "tse/new"      : "newTimeSheetEntry"
    "tse/index"    : "index"
    "tse/:id/edit" : "edit"
    "tse/:id"      : "show"
    "tse/.*"       : "index"

  newTimeSheetEntry: ->
    @view = new TimeSheet.Views.TimeSheetEntries.NewView(collection: @time_sheet_entries, template_url: @new_url)
    $("#time_sheet_entries").html(@view.render().el)

  index: ->
    @view = new TimeSheet.Views.TimeSheetEntries.IndexView(time_sheet_entries: @time_sheet_entries)
    $("#time_sheet_entries").html(@view.render().el)

  show: (id) ->
    time_sheet_entry = @time_sheet_entries.get(id)

    @view = new TimeSheet.Views.TimeSheetEntries.ShowView(model: time_sheet_entry)
    $("#time_sheet_entries").html(@view.render().el)

  edit: (id) ->
    time_sheet_entry = @time_sheet_entries.get(id)

    @view = new TimeSheet.Views.TimeSheetEntries.EditView(model: time_sheet_entry, template_url: @edit_url)
    $("#time_sheet_entries").html(@view.render().el)
