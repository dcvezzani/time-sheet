Backbone.View.afterCreateDoneDefault = function(self, jqXHR){ /* override this */ }
  
Backbone.View.afterCreateFailDefault = function(self, jqXHR, textStatus){
  self.renderHtml(jqXHR.responseText);
} 

/*
 * Post data create/update through html requests to the Rails controller
 *
 * form:    selector or form object representing the form that should be submitted
 * options: #success and #error call backs
 */
Backbone.View.prototype.postViaHtml = function(form, options){
  self = this
  href = $(form).attr("action")
  //console.log("href: " + href)
  form_data = $(form).serialize()
  //console.log("form_data: " + form_data)

  $.post(href, form_data, function(spouse){
    //console.log("done")
  })
  .done(function(jqXHR, textStatus){
    //console.log("done (2)")
    if(options.success){
      options.success(jqXHR)
    } else {
      Backbone.View.afterCreateDoneDefault(self, jqXHR)
    }
  })
  .fail(function(jqXHR, textStatus){
    //console.log("fail")
    if(options.error){
      options.error(jqXHR, textStatus)
    } else {
      Backbone.View.afterCreateFailDefault(self, jqXHR, textStatus)
    }
  })
  .always(function(jqXHR, textStatus){
    //console.log("always")
  })
}

/*
 * Post-processing that may take place after #render() is called.
 */
Backbone.View.prototype.afterRender = function(){
  //over-ride in respective Backbone view
  var self = this
  var formElement = self.$("form").find("input[type='text'], textarea").first();

  $(formElement).focus().select();
}

/*
 * Pull an updated list of JSON objects from the server.
 * Then render using the specified Backbone route.
 *
 * collection_name  : [String] the collection name associated with *this* route
 * path             : [String] route name for the resulting page to render
 */
Backbone.Router.prototype.refreshCollectionAndRenderFor = function(collection_name, path){
  var self = this;

  self[collection_name].fetch({
    success: function(model, response, options){
      self.navigate(path, {trigger: true})
    }, 

    error: function(model, xhr, options){
      alert('parse error!  A JSON response was expected.  Make sure both JSON and HTML are being rendered by the controller.');
    }
  })
}

/*
 * Common module for rendering html returned from the controller from an 'html' request.
 * If html is provided, use it instead of going through the template method call.
 * Define your view's own #afterRender method for custom post-processing.
 *
 * Usage: 
 *   e.g., in 'new_view.js.coffee'
 *   render: Backbone.View.renderContent
 */
Backbone.View.renderContent = function(html){
  self = this;

  if(typeof(html) == "undefined"){
    self.template(self.model.toJSON(), function(html){
      self.$el.html(html);
    })

  } else {
    self.$el.html(html)
  }

  setTimeout( function(){ 
    // continue benefitting from automatic binding
    // rails-backbone-0.9.0/vendor/assets/javascripts/backbone_datalink.js
    self.$("form").backboneLink(self.model)

    self.afterRender() 
  }, 50 );

  return self;
}

