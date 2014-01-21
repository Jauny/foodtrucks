// Pin view
PinView = Backbone.View.extend({
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

  // shows the marker's infowindow
  showPin: function() {
    this.infowindow.open(this.options.map, this.marker);
  }
});
