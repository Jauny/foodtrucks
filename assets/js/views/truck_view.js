// Truck model view
TruckView = Backbone.View.extend({
  tagName: 'a',
  className: 'truck list-group-item',
  template: _.template($('#truck-item-template').html()),

  events:{
    'click': 'showPins'
  },

  showPins: function(){
    this.collection.trigger('closePins');
    this.model.trigger('showPins');
  },

  render: function(query){
    this.$el.html(this.template(this.model));
    return this;
  }
});
