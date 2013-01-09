class TimeSheet.Models.TimeSheetEntry extends Backbone.Model
  paramRoot: 'time_sheet_entry'

  defaults:
    starts_at: null
    ends_at: null
    starts_at: null
    user_id: null
    summary: null
    content: null

  secureAttributes: [
    'created_at', 'updated_at'
  ]

  toJSON: ->
    @_cloneAttributes();

  _cloneAttributes: ->
    attributes = _.clone(@attributes)
    for sa in @secureAttributes
      delete attributes[sa]
    _.clone(attributes)

class TimeSheet.Collections.TimeSheetEntriesCollection extends Backbone.Collection
  model: TimeSheet.Models.TimeSheetEntry
  url: '/time_sheet_entries'
