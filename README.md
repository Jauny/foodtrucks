# SF Food trucks map
http://eatlikeadiplomat.herokuapp.com/

By [Jonathan Pepin](http://www.jypepin.com/) - [LinkedIn](http://linkedin.com/in/jypepin)

### Stack
* Sinatra with Sprockets for Asset Pipeline
* Backbone
* Underscore
* Google Maps API v3
* sfdata.org

### Backend
App is pretty straight forward, and with a Backbone front-end, everything is taken care of in the front end.
Therefore, Sinatra seems to be a correct choice for it. Easy, simple, light, it's perfect to offer a really simple and straight-forward RESTful backend for such a small app.

### Front End
Learnt Backbone through the development of this app. Seemed to be a good front-end framework to allow a responsive and dynamic single page app, with trucks list and the map sharing the same models/collections.

### To do
* ~~loading screen~~
* geolocalisation is too slow (give a few seconds to the "Find trucks close to me" button to get your geo and then filter. It works, it just takes a few seconds!
* search trucks around specific address/location
* filter data based on map position
* save trucks to favorites
* paginate / find a smarter way to filter trucks and not have so many on the map


#### Attributions for icons
Cart icon was made by [Jon Trillana](http://thenounproject.com/claxxmoldii/) and the Truck icon by [Nate Eul](http://thenounproject.com/nateeul/) both from The Noun Project, and both with a [Creative Commons](http://creativecommons.org/licenses/by/3.0/us/) license.
