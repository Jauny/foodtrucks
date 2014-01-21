// Search View
SearchView = Backbone.View.extend({
  el: '#search',

  events: {
    'keyup #truck-search': 'searchTrucks',
    'click #find-trucks-close' : 'closeByTrucks'
  },

  searchTrucks: function(e) {
    query = $(e.currentTarget).val();

    this.collection.trigger('filter', query);
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
        console.error(err)
      }, positionOptions);

    } else {
      console.log('no geolocation');
    }
  },
});
