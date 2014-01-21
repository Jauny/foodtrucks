// Trucks Collection
Trucks = Backbone.Collection.extend({
  // holds truck model
  model: Truck,
  url: '/trucks',

  // this allows to keep the original list to reset search
  filteredTrucks: null,

  // keep user geolocation for chaining searches
  userPosition: null,

  initialize: function() {
    this.listenTo(this, 'filter', this.filter);
    this.listenTo(this, 'closeByTrucks', this.closeByTrucks);
  },

  // filters the collection when user does a search
  filter: function(query) {
    var filteredTrucks = _.filter(this.models, function(truck) {
      return (truck.attributes.applicant.toLowerCase().indexOf(query.toLowerCase()) !== -1) ||
             (truck.attributes.fooditems.toLowerCase().indexOf(query.toLowerCase()) !== -1) ||
             (truck.attributes.facilitytype.toLowerCase().indexOf(query.toLowerCase()) !== -1);
    });

    // checks if we have user's geolocations and filters
    if (this.userPosition) {
      filteredTrucks = this.closeByTrucks(filteredTrucks);
    }

    this.filteredTrucks = new Trucks(filteredTrucks);
    this.trigger('filtered');
  },

  // filters the list for trucks around
  closeByTrucks: function(filteredTrucks) {
    var lat  = this.userPosition.coords.latitude,
        long = this.userPosition.coords.longitude;

    var closeByTrucks = [];

    _.each(filteredTrucks, function(truck) {
      var locs = [];

      _.each(truck.attributes.location, function(loc) {
        if (
        (parseFloat(loc.latitude) < (lat + 0.01)) &&
        (parseFloat(loc.latitude) > (lat - 0.01)) &&
        (parseFloat(loc.longitude) > (long - 0.01)) &&
        (parseFloat(loc.longitude) < (long + 0.01)) ) {
          locs.push(loc);
        }
      });

      if (locs.length) {
        var _truck = _.clone(truck.attributes);
        _truck.location = locs;
        closeByTrucks.push(_truck);
      }
    });

    return closeByTrucks;
  }
});
