// Search View
SearchView = Backbone.View.extend({
  el: '#search',

  events: {
    'keyup #truck-search': 'searchTrucks'
  },

  searchTrucks: function(e) {
    query = $(e.currentTarget).val();

    this.collection.trigger('filter', query);
  }
});
