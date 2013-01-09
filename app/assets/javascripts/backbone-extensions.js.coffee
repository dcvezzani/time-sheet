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

