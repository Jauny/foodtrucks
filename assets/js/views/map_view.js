// Map view
MapView = Backbone.View.extend({
  el: '#map-canvas',

  initialize: function() {
    // adds the event add to add an element to the collection
    this.listenTo(this.collection, 'add', this.addOne);
    this.listenTo(this.collection, 'reset', this.render);
    this.listenTo(this.collection, 'closePins', this.closePins);
    this.listenTo(this.collection, 'filtered', this.renderFiltered);
    this.listenTo(this.collection, 'renderCloseByTrucks', this.renderCloseByTrucks);

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
        new PinView({
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

  renderFiltered: function() {
    _.each(this.pinViews, function(pin) {
      pin.marker.setMap(null);
      pin.remove();
    });
    this.collection.filteredTrucks.forEach(this.addOne, this);

    return this;
  },

  renderCloseByTrucks: function() {
    _.each(this.pinViews, function(pin) {
      pin.marker.setMap(null);
      pin.remove();
    });
    this.collection.closeByTrucks.forEach(this.addOne, this);

    return this;
  },

  closePins: function() {
    _.each(this.pinViews, function(pin) {
      pin.infowindow.close();
    });
  }
});
