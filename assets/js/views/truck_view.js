// Truck model view
TruckView = Backbone.View.extend({
  tagName: 'a',
  className: 'truck list-group-item',
  template: _.template($('#truck-item-template').html()),

  events:{
    'click': 'showPins'
  },

  // show truck's infowindow on map
  showPins: function() {
    this.collection.trigger('closePins');
    this.model.trigger('showPins');
  },

  render: function() {
    this.$el.html(this.template(this.model));
    return this;
  }
});
