Backbone.Router.prototype.refreshCollectionAndRenderFor = function(collection_name, path){
  var self = this;

  self[collection_name].fetch({
    success: function(model, response, options){
      self.navigate(path, {trigger: true})
    }, 

    error: function(model, xhr, options){
      alert('parse error!  Are you allowing both JSON and HTML to be rendered from the controller?');
    }
  })
}

