$(function () {

  var App = {
    Models: {},
    Views: {},
    Collections: {}
  };

  // Truck Model
  App.Models.Truck = Backbone.Model.extend({
    rootURL: '/trucks',

    food: function() {
      return this.attributes.fooditems.split(":");
    },

    icon: function() {
      return this.attributes.facilitytype == 'Truck' ? 'images/truck2.png' : 'images/pushcart.png';
    }
  });

  // Trucks Collection
  App.Collections.Trucks = Backbone.Collection.extend({
    // holds truck model
    model: App.Models.Truck,
    url: '/trucks',

    filter: function(query) {
      var filteredTrucks = _.filter(this.models, function(truck) {
        return truck.attributes.applicant.toLowerCase().indexOf(query.toLowerCase()) !== -1;
      });

      return new App.Collections.Trucks(filteredTrucks);
    }
  });

  // Truck model view
  App.Views.TruckView = Backbone.View.extend({
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

  // Trucks collection view
  App.Views.TrucksView = Backbone.View.extend({
    el: $('#trucks'),

    initialize: function() {
      // adds the event add to add an element to the collection
      this.listenTo(this.collection, 'add', this.addOne);
      this.listenTo(this.collection, 'reset', this.render);
      this.listenTo(this.collection, 'filter', this.renderFiltered);
    },

    addOne: function(model) {
      var truckView = new App.Views.TruckView({ model: model, collection: this.collection });

      // append the new view to the DOM
      this.$el.append(truckView.render().el);
    },

    // renders the list
    render: function() {
      this.$el.html('');
      this.collection.forEach(this.addOne, this);
      return this;
    },

    // renders the filtered list
    renderFiltered: function(query) {
      this.$el.html('');
      this.collection.filter(query).forEach(this.addOne, this);
      return this;
    }
  });

  // Search View
  App.Views.SearchView = Backbone.View.extend({
    el: '#search',

    events: {
      'keyup #truck-search': 'searchTrucks'
    },

    searchTrucks: function(e) {
      query = $(e.currentTarget).val();

      this.collection.trigger('filter', query);
    }
  });

  // Pin view
  App.Views.PinView = Backbone.View.extend({
    initialize: function(options) {
      var _this = this;
      _this.options = options;

      // set values for marker
      var latLng = new google.maps.LatLng(
        _this.options.latitude,
        _this.options.longitude
      );
      var icon = _this.model.icon();

      // put marker on map
      this.marker = new google.maps.Marker({
        position: latLng,
        map: _this.options.map,
        animation: google.maps.Animation.DROP,
        title: _this.model.attributes.applicant,
        icon: icon
      });

      // marker's popup
      this.infowindow = new google.maps.InfoWindow({
          content: _this.model.attributes.applicant
      });
      google.maps.event.addListener(this.marker, 'click', function() {
        _this.collection.trigger('closePins');
        _this.model.trigger('showPins');
      });

      this.listenTo(this.model, 'showPins', this.showPin);
    },

    showPin: function() {
      this.infowindow.open(this.options.map, this.marker);
    }

  });

  // Map view
  App.Views.MapView = Backbone.View.extend({
    el: $('#map-canvas'),

    initialize: function() {
      // adds the event add to add an element to the collection
      this.listenTo(this.collection, 'add', this.addOne);
      this.listenTo(this.collection, 'reset', this.render);
      this.listenTo(this.collection, 'closePins', this.closePins);

      var mapOptions = {
        center: new google.maps.LatLng(37.7745948, -122.4127949),
        zoom: 13
      };
      this.map = new google.maps.Map(this.el,
          mapOptions);

      this.pinViews = [];
    },

    addOne: function(model) {
      var _this = this;

      _.each(model.attributes.location, function(location) {
        _this.pinViews.push(
          new App.Views.PinView({
            model: model,
            collection: _this.collection,
            longitude: location.longitude,
            latitude: location.latitude,
            map: _this.map
          })
        )
      });
    },

    render: function() {
      this.collection.forEach(this.addOne, this);
      return this;
    },

    closePins: function() {
      _.each(this.pinViews, function(pin) {
        pin.infowindow.close();
      });
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
      this.SearchView = new App.Views.SearchView({
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
  window.app = new App.Views.App();
});

