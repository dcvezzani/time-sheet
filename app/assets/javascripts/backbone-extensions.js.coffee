Backbone.Model.extractAttributes = (form, options) ->
  namespace = options.namespace
  update_attrs = {}
  re = new RegExp(namespace + "\\\[([^\\\]]+)\\\]")
  md = null
  timedate_fields = {}

  #console.log("fields: " + $("input[name^='" + namespace + "'], textarea[name^='" + namespace + "'], select[name^='" + namespace + "']", form))

  form_elements = $("input[name^='" + namespace + "'], textarea[name^='" + namespace + "'], select[name^='" + namespace + "']", form)
  for field in form_elements
    field_name = field.name.replace(re, "$1")
    #console.log("field_name: " + field_name)

    if(md = field_name.match(/^([^\(]+)\(([^\)]+)\)/))
      field_name = md[1]
      timedate_fields[field_name] = true

      if(!update_attrs[field_name])
        update_attrs[field_name] = []

      hash_item = {}
      hash_item[md[2]] = $(field).val()
      update_attrs[field_name][update_attrs[field_name].length] = hash_item

    else if(($(field).attr("type")).match(/checkbox|radio/))
      update_attrs[field_name] = (($(field).is(":checked")) ? "1" : "0")
      
    else
      update_attrs[field_name] = $(field).val()

  for field of timedate_fields
    update_attrs[field] = Backbone.Model.compileDateTime(update_attrs[field])

  update_attrs

Backbone.Model.compileDateTime = (attr, options) ->
  values = []
  for sub_attr in attr
    value = null
    for prop of sub_attr
      value = sub_attr[prop]

    values[values.length] = value

  values[0] + "-" + values[1] + "-" + values[2] + " " + values[3] + ":" + values[4]

Backbone.View.afterCreateDoneDefault = (self, jqXHR) =>
  # override this
  
Backbone.View.afterCreateFailDefault = (self, jqXHR, textStatus) =>
  self.renderHtml(jqXHR.responseText)
  
Backbone.View.prototype.postViaHtml = (form, options) =>
  self = this
  href = $(form).attr("action")
  #console.log("href: " + href)
  form_data = $(form).serialize()
  #console.log("form_data: " + form_data)

  $.post(href, form_data, (spouse) ->
    #console.log("done")
  )
  .done((jqXHR, textStatus) ->
    #console.log("done (2)")
    if(options.success)
      options.success(jqXHR)
    else
      Backbone.View.afterCreateDoneDefault(self, jqXHR)
  )
  .fail((jqXHR, textStatus) ->
    #console.log("fail")
    if(options.success)
      options.success(jqXHR, textStatus)
    else
      Backbone.View.afterCreateFailDefault(self, jqXHR, textStatus)
  )
  .always((jqXHR, textStatus) ->
    #console.log("always")
  )

Backbone.View.prototype.createViaHtml = Backbone.View.prototype.postViaHtml

Backbone.View.prototype.renderHtml = (form, html) =>
  #@template(@model.toJSON(), (html) -> 
  @$el.html(html)

  setTimeout(->
    @$(form).backboneLink(@model)
  50
  )
  #)

###
# can't get this to work in CoffeeScript; I've put it in backbone-extensions-002.js for now

Backbone.Router.prototype.refreshCollectionAndRenderFor = (collection_name, path) =>
  this[collection_name].fetch( 
    success: (model, response, options) ->
      @navigate(path, {trigger: true})

    error: (model, xhr, options) ->
      alert('parse error!  Are you allowing both JSON and HTML to be rendered from the controller?')
  )
###
