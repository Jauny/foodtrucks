// Trucks collection view
TrucksView = Backbone.View.extend({
  el: $('#trucks'),

  initialize: function() {
    // adds the event add to add an element to the collection
    this.listenTo(this.collection, 'add', this.addOne);
    this.listenTo(this.collection, 'reset', this.render);
    this.listenTo(this.collection, 'filtered', this.renderFiltered);
  },

  addOne: function(model) {
    var truckView = new TruckView({ model: model, collection: this.collection });

    // append the new view to the DOM
    this.$el.append(truckView.render().el);
  },

  // renders the list
  render: function() {
    this.$el.html('');
    this.collection.forEach(this.addOne, this);

    return this;
  },

  // renders the filtered list when user makes a search
  renderFiltered: function(query) {
    this.$el.html('');
    this.collection.filteredTrucks.forEach(this.addOne, this);

    return this;
  }
});
