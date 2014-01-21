// Trucks Collection
Trucks = Backbone.Collection.extend({
  model: Truck,
  url: '/trucks',

  // this allows to keep the original list to reset search
  filteredTrucks: null,

  // keep user geolocation for chaining searches
  userPosition: null,

  initialize: function() {
    this.listenTo(this, 'filter', this.filter);
  },

  // filters the collection when user does a search
  filter: function(query) {
    query = query.trim().toLowerCase();

    this.filteredTrucks = this;

    if(query && query.length) {
      this.filterByQuery(query);
    }

    // checks if we have user's geolocations and filters
    if (this.userPosition) {
      this.closeByTrucks();
    }

    this.trigger('filtered');
  },

  filterByQuery: function(query) {
    var trucks = _.filter(this.filteredTrucks.models, function(truck) {
      return (truck.attributes.applicant.toLowerCase().indexOf(query) !== -1) ||
             (truck.attributes.fooditems.toLowerCase().indexOf(query) !== -1) ||
             (truck.attributes.facilitytype.toLowerCase().indexOf(query) !== -1);
    });

    this.filteredTrucks = new Trucks(trucks);
  },

  // filters the list for trucks around
  closeByTrucks: function() {
    var lat  = this.userPosition.coords.latitude,
        long = this.userPosition.coords.longitude,
        closeByTrucks = [];

    _.each(this.filteredTrucks.models, function(truck) {
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

    this.filteredTrucks = new Trucks(closeByTrucks);
  }
});
