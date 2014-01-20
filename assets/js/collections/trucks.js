// Trucks Collection
Trucks = Backbone.Collection.extend({
  // holds truck model
  model: Truck,
  url: '/trucks',

  filter: function(query) {
    var filteredTrucks = _.filter(this.models, function(truck) {
      return truck.attributes.applicant.toLowerCase().indexOf(query.toLowerCase()) !== -1;
    });

    return new Trucks(filteredTrucks);
  }
});
