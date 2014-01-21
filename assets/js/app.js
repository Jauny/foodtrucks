//= require vendors/jquery
//= require vendors/underscore
//= require vendors/backbone
//= require_tree ./models
//= require_tree ./collections
//= require_tree ./views

$(function () {
  App = Backbone.View.extend({
    el: $('#app'),

    initialize: function() {
      this.trucks = new Trucks();
      this.trucksView = new TrucksView({
        collection: this.trucks
      });
      this.SearchView = new SearchView({
        collection: this.trucks
      });
      this.mapView = new MapView({
        collection: this.trucks
      });

      // gets the trucks from /trucks
      this.trucks.fetch({
        reset: true
      });

    }
  });

  // initialize everything
  window.app = new App();
});

