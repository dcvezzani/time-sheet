class TimeSheet.Models.Topic extends Backbone.Model
  paramRoot: 'topic'

  defaults:
    name: null
    description: null

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

class TimeSheet.Collections.TopicsCollection extends Backbone.Collection
  model: TimeSheet.Models.Topic
  url: '/topics_bb'
