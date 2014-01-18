$(function () {

  var App = {
    Models: {},
    Views: {},
    Collections: {}
  };

  // Truck Model
  App.Models.Truck = Backbone.Model.extend({
    rootURL: '/trucks'
  });

  // Trucks Collection
  App.Collections.Trucks = Backbone.Collection.extend({
    // holds truck model
    model: App.Models.Truck,
    url: '/trucks'
  });

  // Truck model view
  App.Views.TruckView = Backbone.View.extend({
    tagName: 'div',
    className: 'truck',
    template: _.template($('#truck-item-template').html()),

    render: function(){
      this.$el.html(this.template(this.model.toJSON()));
      return this;
    }

  });

  // Trucks collection view
  App.Views.TrucksView = Backbone.View.extend({
    el: $('#trucks'),

    initialize: function() {
      // adds the event add to add an element to the collection
      this.listenTo(this.collection, 'add', this.addOne);
      this.listenTo(this.collection, 'reset', this.render);
    },

    addOne: function(model) {
      var truckView = new App.Views.TruckView({ model: model });

      // append the new view to the DOM
      this.$el.append(truckView.render().el);
    },

    // renders the list
    render: function() {
      this.collection.forEach(this.addOne, this);
      return this;
    }
  });

  // Pin view
  App.Views.PinView = Backbone.View.extend({
    initialize: function(options) {
      var _this = this;
      _this.options = options;

      // set values for marker
      var latLng = new google.maps.LatLng(_this.model.attributes.location.latitude, _this.model.attributes.location.longitude);
      var icon = _this.model.attributes.facilitytype == 'Truck' ? 'images/truck2.png' : 'images/pushcart.png'

      // put marker on map
      var marker = new google.maps.Marker({
        position: latLng,
        map: _this.options.map,
        animation: google.maps.Animation.DROP,
        title: _this.model.attributes.applicant,
        icon: icon
      });

      // marker's popup
      openedWindow = null; // global scope to close last opened
      var infowindow = new google.maps.InfoWindow({
          content: _this.model.attributes.applicant
      });
      google.maps.event.addListener(marker, 'click', function() {
        if (openedWindow) openedWindow.close();
        openedWindow = infowindow;
        infowindow.open(_this.options.map, marker);
      });
    }
  });

  // Map view
  App.Views.MapView = Backbone.View.extend({
    el: $('#map-canvas'),

    initialize: function() {
      // adds the event add to add an element to the collection
      this.listenTo(this.collection, 'add', this.addOne);
      this.listenTo(this.collection, 'reset', this.render);

      var mapOptions = {
        center: new google.maps.LatLng(37.7745948, -122.4127949),
        zoom: 13
      };
      this.map = new google.maps.Map(this.el,
          mapOptions);
    },

    addOne: function(model) {
      var pinView = new App.Views.PinView({
        model: model,
        map: this.map
      });
    },

    render: function() {
      this.collection.forEach(this.addOne, this);
      return this;
    }
  });

  // Global app element
  App.Views.App = Backbone.View.extend({
    el: $('#app'),

    initialize: function() {
      this.trucks = new App.Collections.Trucks();

      this.trucksView = new App.Views.TrucksView({
        collection: this.trucks
      });

      this.mapView = new App.Views.MapView({
        collection: this.trucks
      });

      this.trucks.fetch({
        reset: true
      });

    }
  });

  // initialize everything
  var app = new App.Views.App();
});
