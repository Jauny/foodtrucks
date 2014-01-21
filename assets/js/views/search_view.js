// Search View
SearchView = Backbone.View.extend({
  el: '#search',

  events: {
    'keyup #truck-search': 'searchTrucks',
    'click #find-trucks-close' : 'getUserPosition',
    'click #reset-trucks-close' : 'resetUserPosition'
  },

  searchTrucks: function() {
    query = $('#truck-search').val();

    this.collection.trigger('filter', query);
  },

  // user navigator to save user's location to trucks collection
  getUserPosition: function() {
    this.toggleGeoLoading();
    var _this = this;

    if (navigator.geolocation) {
      var positionOptions = {
        enableHighAccuracy: true,
        timeout: 10 * 1000 // 10 seconds
      };

      navigator.geolocation.getCurrentPosition(
        function(position) {
          _this.collection.userPosition = position;
          _this.searchTrucks();
      }, function(err) {
        alert('no position found...');
      }, positionOptions);

    } else {
      alert('no position found...');
    }

    _this.toggleGeoLoading();
  },

  // resets user location to null in trucks collection
  resetUserPosition: function() {
    this.collection.userPosition = null;
    this.searchTrucks();
  },

  toggleGeoLoading: function() {
    $('#geotext').toggle();
    $('#geoloading').toggle();
  }
});
