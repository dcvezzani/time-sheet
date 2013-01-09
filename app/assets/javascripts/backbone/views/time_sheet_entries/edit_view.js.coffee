TimeSheet.Views.TimeSheetEntries ||= {}

class TimeSheet.Views.TimeSheetEntries.EditView extends Backbone.View
  template: (model, callback) -> _.template(
    #href = $("#edit-time-sheet-entry-from-erb").attr("href").replace(/__xxx__/, model.id)
    href = @template_url.replace(/__xxx__/, model.id)
    console.log("edit href: " + href)

    $.get(href, (data) ->
      callback(data)
    )
  )

  events:
    "submit .edit-timesheetentry": "update"

  constructor: (options) ->
    super(options)
    @template_url = options.template_url

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    form = $(e.target)
    @model.unset("errors")

    @postViaHtml(form, 
      success: (time_sheet_entry) =>
        window.time_sheet_router.refreshCollectionAndRenderFor("time_sheet_entries", '/tse/index')

      error: (jqXHR, status) =>
        @renderHtml(jqXHR.responseText)
    )

  afterRender: ->
    $("#time_sheet_entry_summary").focus().select()

  render: Backbone.View.renderContent
