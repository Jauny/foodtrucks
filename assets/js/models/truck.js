// Truck Model
Truck = Backbone.Model.extend({
  rootURL: '/trucks',

  food: function() {
    return this.attributes.fooditems.split(":");
  },

  icon: function() {
    return this.attributes.facilitytype == 'Truck' ? 'assets/truck2.png' : 'assets/pushcart.png';
  }
});
