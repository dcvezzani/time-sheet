TimeSheet.Views.TimeSheetEntries ||= {}

class TimeSheet.Views.TimeSheetEntries.NewView extends Backbone.View
  template: (model, callback) -> _.template(
    #href = $("#new-time-sheet-entry-from-erb").attr("href")
    href = @template_url
    console.log("new href: " + href)

    $.get(href, (data) ->
      callback(data)
    )
  )

  events:
    "submit .new-timesheetentry": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()
    @template_url = options.template_url

    @model.bind("change:errors", () =>
      @render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    form = $(e.target)
    @model.unset("errors")

    @postViaHtml(form, 
      success: (time_sheet_entry) =>
        window.time_sheet_router.refreshCollectionAndRenderFor("time_sheet_entries", '/tse/index')

      error: (jqXHR, status) =>
        @render(jqXHR.responseText)
    )

  afterRender: ->
    $("#time_sheet_entry_summary").focus().select()

  render: Backbone.View.renderContent
