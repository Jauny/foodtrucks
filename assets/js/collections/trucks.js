// Trucks Collection
Trucks = Backbone.Collection.extend({
  // holds truck model
  model: Truck,
  url: '/trucks',
  filteredTrucks: null,

  initialize: function() {
    this.listenTo(this, 'filter', this.filter);
    this.listenTo(this, 'closeByTrucks', this.closeByTrucks);
  },

  filter: function(query) {
    var filteredTrucks = _.filter(this.models, function(truck) {
      return (truck.attributes.applicant.toLowerCase().indexOf(query.toLowerCase()) !== -1) ||
             (truck.attributes.fooditems.toLowerCase().indexOf(query.toLowerCase()) !== -1) ||
             (truck.attributes.facilitytype.toLowerCase().indexOf(query.toLowerCase()) !== -1);
    });

    this.filteredTrucks = new Trucks(filteredTrucks);
    this.trigger('filtered');
  },

  closeByTrucks: function(userPosition) {
    var lat  = userPosition.coords.latitude,
        long = userPosition.coords.longitude;

    var closeByTrucks = [];

    _.each(this.models, function(truck) {
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

    this.closeByTrucks = new Trucks(closeByTrucks);
    this.trigger('renderCloseByTrucks');
  }
});
