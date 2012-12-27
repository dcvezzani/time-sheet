  function ViewAdjustment(){
    this.adjustmentIdentifiers = {}
  }
  new ViewAdjustment();
  ViewAdjustment.prototype.add = function(selector, func){
    this.adjustmentIdentifiers[selector] = func;
  }
  ViewAdjustment.prototype.adjustments = function(win){
    for(prop in this.adjustmentIdentifiers){
      this.adjustmentIdentifiers[prop](prop, win);
    }
  }

