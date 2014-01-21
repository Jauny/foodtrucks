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

  getUserPosition: function() {
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
  },

  resetUserPosition: function() {
    this.collection.userPosition = null;
    this.searchTrucks();
  },

  closeByTrucks: function() {
    var _this = this;

    if (navigator.geolocation) {
      var positionOptions = {
        enableHighAccuracy: true,
        timeout: 10 * 1000 // 10 seconds
      };

      navigator.geolocation.getCurrentPosition(function(userPosition) {
        _this.collection.trigger('closeByTrucks', userPosition);
      }, function(err) {
        alert("Sorry, we couldn't find any geolocation.");
      }, positionOptions);

    } else {
      alert("Sorry, we couldn't find any geolocation.");
    }
  },
});
