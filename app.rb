require 'sinatra/base'
require 'bundler/setup'
require 'sprockets'
require 'sprockets-helpers'

class App < Sinatra::Base
  set :assets, Sprockets::Environment.new(root)

  configure do
    assets.append_path File.join(root, 'assets', 'css')
    assets.append_path File.join(root, 'assets', 'js')
    assets.append_path File.join(root, 'assets', 'images')

    Sprockets::Helpers.configure do |config|
      config.environment = assets
      config.prefix      = '/assets'
      config.digest      = true
    end
    end

    helpers do
      include Sprockets::Helpers
    end

  get '/' do
    haml :index
  end

  get '/trucks' do
    # get trucks from api
    trucks = HTTParty.get("http://data.sfgov.org/resource/fi3h-6q7h.json")

    # get trucks from cached data
    # trucks = get_trucks

    # some trucks have no location
    trucks.select! { |truck| !!truck["location"] }

    # uniqify trucks
    trucks_permits = Hash.new
    trucks.each do |truck|
      if trucks_permits[truck["applicant"]]
        trucks_permits[truck["applicant"]]["location"] << truck["location"]
      else
        trucks_permits[truck["applicant"]] = truck
        trucks_permits[truck["applicant"]]["location"] = [trucks_permits[truck["applicant"]]["location"]]
      end
    end

    trucks_permits.values.to_json
  end

  private
  def get_trucks
    return JSON.parse '[{"location":{"needs_recoding":false,"longitude":"-122.390471540322","latitude":"37.7875875185016"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0057","block":"3767","received":"Mar 13 2013  2:15PM","facilitytype":"Truck","blocklot":"3767079","locationdescription":"HARRISON ST: 16TH ST \\ TREAT AVE to 17TH ST (2000 - 2099)","cnn":"6745000","priorpermit":"1","approved":"2013-03-13T14:46:23","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0057&ExportPDF=1&Filename=13MFF-0057_schedule.pdf","address":"2010 HARRISON ST","applicant":"John\'s Catering #5","lot":"079","fooditems":"Cold Truck: Soda:Chips:Candy: Cold/Hot Sandwiches: Donuts.  (Pitco Wholesale)","longitude":"-122.390471540332","latitude":"37.7875875047281","objectid":"427604","y":"2114757.862","x":"6015409.638"},{"location":{"needs_recoding":false,"longitude":"-122.399520766934","latitude":"37.7862510212184"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0058","block":"3722","received":"Mar 13 2013  2:47PM","facilitytype":"Truck","blocklot":"3722022","locationdescription":"NEW MONTGOMERY ST: NATOMA ST to HOWARD ST (158 - 199)","cnn":"9546000","priorpermit":"1","approved":"2013-04-12T13:54:59","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0058&ExportPDF=1&Filename=13MFF-0058_schedule.pdf","address":"180 NEW MONTGOMERY ST","applicant":"Sunrise Catering","lot":"022","fooditems":"Cold Truck: sandwiches: drinks: snacks: candy: hot coffee","longitude":"-122.399520766943","latitude":"37.7862510074437","objectid":"427623","y":"2114324.261","x":"6012785.32"},{"location":{"needs_recoding":false,"longitude":"-122.4128722942","latitude":"37.7714672296901"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0063","block":"3520","received":"Mar 14 2013  2:35PM","facilitytype":"Truck","blocklot":"3520027","locationdescription":"11TH ST: FOLSOM ST to HARRISON ST (300 - 399)","cnn":"515000","priorpermit":"1","approved":"2013-03-19T14:01:19","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0063&ExportPDF=1&Filename=13MFF-0063_schedule.pdf","address":"355 11TH ST","applicant":"Mini Mobile Food Catering","lot":"027","fooditems":"Cold Truck: Corn Dogs: Noodle Soups: Candy: Pre-packaged Snacks: Sandwiches: Chips: Coffee: Tea: Various Beverages","longitude":"-122.41287229421","latitude":"37.771467215901","objectid":"427831","y":"2109020.872","x":"6008817.805"},{"location":{"needs_recoding":false,"longitude":"-122.398835922435","latitude":"37.778266590477"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0071","block":"3777","received":"Mar 15 2013 10:16AM","facilitytype":"Truck","blocklot":"3777051","locationdescription":"BRYANT ST: 04TH ST \\ I-80 E OFF RAMP to 05TH ST \\ I-80 E ON RAMP (600 - 699)","cnn":"3285000","priorpermit":"1","approved":"2013-03-29T09:33:44","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0071&ExportPDF=1&Filename=13MFF-0071_schedule.pdf","address":"645 BRYANT ST","applicant":"Quan Catering","lot":"051","fooditems":"Cold Truck: Soft drinks: cup cakes: potato chips: cookies: gum: sandwiches (hot & cold): peanuts: muffins: coff (hot & cold): water: juice: yoplait: milk: orange juice: sunflower seeds: can foods: burritos: buscuits: chimichangas: rice krispies","longitude":"-122.398835922445","latitude":"37.7782665766946","objectid":"427903","y":"2111413.539","x":"6012924.199"},{"location":{"needs_recoding":false,"longitude":"-122.412375997312","latitude":"37.7600996792894"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0081","block":"4083","received":"Mar 15 2013  3:46PM","facilitytype":"Truck","blocklot":"4083008","locationdescription":"HARRISON ST: 19TH ST to MISTRAL ST (2301 - 2360)","cnn":"6751000","priorpermit":"1","approved":"2013-03-15T15:49:09","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0081&ExportPDF=1&Filename=13MFF-0081_schedule.pdf","address":"2301 HARRISON ST","applicant":"May Catering","lot":"008","fooditems":"Cold Truck: Sandwiches: fruit: snacks: candy: hot and cold drinks","longitude":"-122.412375997322","latitude":"37.7600996654893","objectid":"428079","y":"2104879.645","x":"6008876.646"},{"location":{"needs_recoding":false,"longitude":"-122.390668459193","latitude":"37.774074855597"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0081","block":"8711","received":"Mar 15 2013  3:46PM","facilitytype":"Truck","blocklot":"8711023","locationdescription":"CHANNEL ST: 03RD ST to 04TH ST (0 - 0)","cnn":"3887000","priorpermit":"1","approved":"2013-03-15T15:49:09","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0081&ExportPDF=1&Filename=13MFF-0081_schedule.pdf","address":"Assessors Block 8711/Lot023","applicant":"May Catering","lot":"023","fooditems":"Cold Truck: Sandwiches: fruit: snacks: candy: hot and cold drinks","longitude":"-122.390668459203","latitude":"37.7740748418105","objectid":"428087","y":"2109839.763","x":"6015253.35"},{"location":{"needs_recoding":false,"longitude":"-122.401093930715","latitude":"37.7271654873259"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0075","block":"5447","received":"Mar 15 2013 11:49AM","facilitytype":"Truck","blocklot":"5447053","locationdescription":"EGBERT AVE: NEWHALL ST to PHELPS ST (1800 - 1899)","cnn":"5118000","priorpermit":"1","approved":"2013-03-26T10:05:29","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0075&ExportPDF=1&Filename=13MFF-0075_schedule.pdf","address":"1843 EGBERT AVE","applicant":"Bach Catering","lot":"053","fooditems":"Cold Truck: Cheeseburgers: Burgers: Chicken Bake: Chili Dogs: Hot Dogs: Corn Dogs: Cup of Noodles: Egg Muffins: Tamales: Hot Sandwiches Quesadillas: Gatorade: Juice: Soda: Mikl: Coffee: Hot Cocoa: Hot Tea: Flan: Fruits: Fruit Salad: Yogurt: Candy: Chips:  Donuts: Cookies: Granola: Muffins & Various Drinks & Pre-Packaged Snacks.","longitude":"-122.401093930725","latitude":"37.7271654734939","objectid":"427968","y":"2092823.701","x":"6011893.793"},{"location":{"needs_recoding":false,"longitude":"-122.395447606293","latitude":"37.787157756913"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0084","block":"3736","received":"Mar 18 2013  2:01PM","facilitytype":"Truck","blocklot":"3736124","locationdescription":"CLEMENTINA ST: 01ST ST to ECKER ST (1 - 37)","cnn":"4194000","priorpermit":"1","approved":"2013-03-20T13:32:58","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0084&ExportPDF=1&Filename=13MFF-0084_schedule.pdf","address":"19 CLEMENTINA ST","applicant":"Paradise Catering","lot":"124","fooditems":"Cold Truck: Sandwiches: snacks: prepackaged items: beverages:","longitude":"-122.395447606303","latitude":"37.7871577431391","objectid":"428478","y":"2114630.492","x":"6013968.817"},{"location":{"needs_recoding":false,"longitude":"-122.391515238762","latitude":"37.7464698019281"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0072","block":"5215","received":"Mar 15 2013 10:24AM","facilitytype":"Truck","blocklot":"5215016","locationdescription":"RANKIN ST: DAVIDSON AVE to EVANS AVE (200 - 299)","cnn":"10927000","priorpermit":"1","approved":"2013-04-04T08:44:08","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0072&ExportPDF=1&Filename=13MFF-0072_schedule.pdf","address":"220 RANKIN ST","applicant":"Park\'s Catering","lot":"016","fooditems":"Cold Truck: Hamburger: cheeseburgers: hot dogs: hot sandwiches: cold sandwiches: egg muffins: cup of noodles: corn dogs: canned soup: coffee: hot cocoa: hot tea: gatorade: juice: milk: soda: water: fruits: fruit salad: rice pudding: yogurt: candy bars: chips: cookies: donuts: granola bars: muffins","longitude":"-122.391515238772","latitude":"37.7464697881148","objectid":"427920","y":"2099795.201","x":"6014805.514"},{"location":{"needs_recoding":false,"longitude":"-122.425161376348","latitude":"37.7644595352382"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0074","block":"3567","received":"Mar 15 2013 11:21AM","facilitytype":"Truck","blocklot":"3567039","locationdescription":"16TH ST: SPENCER ST to DOLORES ST (3220 - 3299)","cnn":"736000","priorpermit":"1","approved":"2013-03-15T11:24:54","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0074&ExportPDF=1&Filename=13MFF-0074_schedule.pdf","address":"3253 16TH ST","applicant":"Daniel\'s Catering","lot":"039","fooditems":"Cold Truck: Breakfast: Sandwiches: Salads: Pre-Packaged Snacks: Beverages","longitude":"-122.425161376358","latitude":"37.7644595214424","objectid":"427950","y":"2106542.595","x":"6005214.088"},{"location":{"needs_recoding":false,"longitude":"-122.397031718968","latitude":"37.7477721054195"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0078","block":"4343","received":"Mar 15 2013  1:12PM","facilitytype":"Truck","blocklot":"4343002","locationdescription":"EVANS AVE: NAPOLEON ST \\ TOLAND ST to MARIN ST (2000 - 2099)","cnn":"5340000","priorpermit":"1","approved":"2013-03-27T14:44:50","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0078&ExportPDF=1&Filename=13MFF-0078_schedule.pdf","address":"2045 EVANS AVE","applicant":"Eva\'s Catering","lot":"002","fooditems":"Cold Truck: Burrito: Corn Dog: Salads: Sandwiches: Quesadilla: Tacos: Fried Rice: Cow Mein: Chinese Rice: Noodle Plates: Soup: Bacon: Eggs: Ham: Avacado: Sausages: Beverages","longitude":"-122.397031718978","latitude":"37.7477720916075","objectid":"427999","y":"2100301.58","x":"6013220.459"},{"location":{"needs_recoding":false,"longitude":"-122.393543363003","latitude":"37.7108379449887"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0081","block":"4991","received":"Mar 15 2013  3:46PM","facilitytype":"Truck","blocklot":"4991086","locationdescription":"EXECUTIVE PARK BLVD: CANDLESTICK COVE WAY to SANDPIPER COVE WAY \\ THOMAS MELLON DR (138 - 198)","cnn":"5372103","priorpermit":"1","approved":"2013-03-15T15:49:09","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0081&ExportPDF=1&Filename=13MFF-0081_schedule.pdf","address":"150 EXECUTIVE PARK BLVD","applicant":"May Catering","lot":"086","fooditems":"Cold Truck: Sandwiches: fruit: snacks: candy: hot and cold drinks","longitude":"-122.393543363013","latitude":"37.710837931141","objectid":"428097","y":"2086835.501","x":"6013956.743"},{"location":{"needs_recoding":false,"longitude":"-122.398235074239","latitude":"37.7863198120587"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0071","block":"3735","received":"Mar 15 2013 10:16AM","facilitytype":"Truck","blocklot":"3735063","locationdescription":"02ND ST: HOWARD ST to TEHAMA ST (200 - 227)","cnn":"135000","priorpermit":"1","approved":"2013-03-29T09:33:44","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0071&ExportPDF=1&Filename=13MFF-0071_schedule.pdf","address":"222 02ND ST","applicant":"Quan Catering","lot":"063","fooditems":"Cold Truck: Soft drinks: cup cakes: potato chips: cookies: gum: sandwiches (hot & cold): peanuts: muffins: coff (hot & cold): water: juice: yoplait: milk: orange juice: sunflower seeds: can foods: burritos: buscuits: chimichangas: rice krispies","longitude":"-122.398235074249","latitude":"37.786319798284","objectid":"427909","y":"2114341.766","x":"6013157.288"},{"location":{"needs_recoding":false,"longitude":"-122.411968357902","latitude":"37.7658204682777"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0081","block":"3927","received":"Mar 15 2013  3:46PM","facilitytype":"Truck","blocklot":"3927004","locationdescription":"16TH ST: FLORIDA ST to ALABAMA ST (2500 - 2599)","cnn":"718000","priorpermit":"1","approved":"2013-03-15T15:49:09","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0081&ExportPDF=1&Filename=13MFF-0081_schedule.pdf","address":"2500 16TH ST","applicant":"May Catering","lot":"004","fooditems":"Cold Truck: Sandwiches: fruit: snacks: candy: hot and cold drinks","longitude":"-122.411968357912","latitude":"37.7658204544832","objectid":"428083","y":"2106959.859","x":"6009037.016"},{"location":{"needs_recoding":false,"longitude":"-122.406879738203","latitude":"37.7872426163705"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0046","block":"0314","received":"Mar 12 2013  4:59PM","facilitytype":"Push Cart","blocklot":"0314001","locationdescription":"GEARY ST: STOCKTON ST to POWELL ST (200 - 299)","cnn":"6109000","priorpermit":"1","approved":"2013-05-02T10:43:28","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0046&ExportPDF=1&Filename=13MFF-0046_schedule.pdf","address":"233 GEARY ST","applicant":"San Francisco Carts & Concessions, Inc. DBA Stanley\'s Steamers Hot Dogs","lot":"001","fooditems":"Hot dogs: condiments: soft pretzels: soft drinks: coffee: cold beverages: pastries: bakery goods: cookies: ice cream: candy: soups: churros: chestnuts: nuts: fresh fruit: fruit juices: desserts: potato chips and popcorn.","longitude":"-122.406879738213","latitude":"37.7872426025967","objectid":"427507","y":"2114728.492","x":"6010666.538"},{"location":{"needs_recoding":false,"longitude":"-122.393549610526","latitude":"37.7569236675372"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0100","block":"4167","received":"Apr  5 2013  8:29AM","facilitytype":"Truck","blocklot":"4167010","locationdescription":"PENNSYLVANIA AVE: 22ND ST to 23RD ST (700 - 899)","cnn":"10336000","priorpermit":"1","approved":"2013-04-08T09:08:58","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0100&ExportPDF=1&Filename=13MFF-0100_schedule.pdf","address":"700 PENNSYLVANIA AVE","applicant":"May Sun Kitchen","lot":"010","fooditems":"Cold Truck: Sandwiches: Noodles:  Pre-packaged Snacks: Candy: Desserts Various Beverages","longitude":"-122.393549610536","latitude":"37.7569236537341","objectid":"434621","y":"2103612.775","x":"6014294.444"},{"location":{"needs_recoding":false,"longitude":"-122.401269695226","latitude":"37.792389875752"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0093","block":"0260","received":"Mar 22 2013  2:25PM","facilitytype":"Truck","blocklot":"0260004","locationdescription":"SANSOME ST: PINE ST to CALIFORNIA ST (200 - 299)","cnn":"11544000","priorpermit":"0","approved":"2013-03-22T16:11:27","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0093&ExportPDF=1&Filename=13MFF-0093_schedule.pdf","address":"217 SANSOME ST","applicant":"Celtic Catering","lot":"004","fooditems":"Eritrean & Irish Fusion Burgers: Irish Stew: Eritrean Stew:  Shepard\'s Pie: Beverages","longitude":"-122.401269695236","latitude":"37.7923898619832","objectid":"429217","y":"2116569.355","x":"6012325.432"},{"location":{"needs_recoding":false,"longitude":"-122.389894366935","latitude":"37.7512694196867"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0100","block":"4317","received":"Apr  5 2013  8:29AM","facilitytype":"Truck","blocklot":"4317015","locationdescription":"26TH ST: MINNESOTA ST to INDIANA ST (1000 - 1099)","cnn":"1500000","priorpermit":"1","approved":"2013-04-08T09:08:58","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0100&ExportPDF=1&Filename=13MFF-0100_schedule.pdf","address":"1051 26TH ST","applicant":"May Sun Kitchen","lot":"015","fooditems":"Cold Truck: Sandwiches: Noodles:  Pre-packaged Snacks: Candy: Desserts Various Beverages","longitude":"-122.389894366944","latitude":"37.7512694058781","objectid":"434628","y":"2101533.012","x":"6015309.355"},{"location":{"needs_recoding":false,"longitude":"-122.385294691178","latitude":"37.7267096892011"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0095","block":"4807","received":"Mar 25 2013  1:45PM","facilitytype":"Truck","blocklot":"4807012","locationdescription":"THOMAS AVE: HAWES ST to INGALLS ST (1200 - 1299)","cnn":"12570000","priorpermit":"1","approved":"2013-03-25T13:50:03","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0095&ExportPDF=1&Filename=13MFF-0095_schedule.pdf","address":"1265 THOMAS AVE","applicant":"Paul\'s Catering","lot":"012","fooditems":"Cold Truck: Pre-packaged sandwiches: snacks: fruit: various beverages","longitude":"-122.385294691187","latitude":"37.7267096753687","objectid":"429439","y":"2092565.342","x":"6016458.774"},{"location":{"needs_recoding":false,"longitude":"-122.396650675254","latitude":"37.796913726248"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0041","block":"0201","received":"Mar 12 2013 11:35AM","facilitytype":"Truck","blocklot":"0201012","locationdescription":"DRUMM ST: WASHINGTON ST intersection","cnn":"24571000","priorpermit":"1","approved":"2013-03-13T09:29:32","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0041&ExportPDF=1&Filename=13MFF-0041_schedule.pdf","address":"370 DRUMM ST","applicant":"Curry Up Now","lot":"012","fooditems":"Chicken Tiki Masala Burritos: Paneer Tiki Masala Burritos: Samosas: Mango Lassi","longitude":"-122.396650675264","latitude":"37.7969137124835","objectid":"427458","y":"2118189.172","x":"6013693.222"},{"location":{"needs_recoding":false,"longitude":"-122.390920264343","latitude":"37.786904933456"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0071","block":"3766","received":"Mar 15 2013 10:16AM","facilitytype":"Truck","blocklot":"3766012","locationdescription":"BEALE ST: HARRISON ST to BRYANT ST (400 - 499)","cnn":"2867000","priorpermit":"1","approved":"2013-03-29T09:33:44","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0071&ExportPDF=1&Filename=13MFF-0071_schedule.pdf","address":"400 BEALE ST","applicant":"Quan Catering","lot":"012","fooditems":"Cold Truck: Soft drinks: cup cakes: potato chips: cookies: gum: sandwiches (hot & cold): peanuts: muffins: coff (hot & cold): water: juice: yoplait: milk: orange juice: sunflower seeds: can foods: burritos: buscuits: chimichangas: rice krispies","longitude":"-122.390920264352","latitude":"37.7869049196819","objectid":"427895","y":"2114511.988","x":"6015274.974"},{"location":{"needs_recoding":false,"longitude":"-122.49007120809","latitude":"37.7835091359901"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0078","block":"1404","received":"Mar 15 2013  1:12PM","facilitytype":"Truck","blocklot":"1404045","locationdescription":"ORTEGA ST: 18TH AVE to 19TH AVE (1100 - 1199)","cnn":"10006000","priorpermit":"1","approved":"2013-03-27T14:44:50","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0078&ExportPDF=1&Filename=13MFF-0078_schedule.pdf","address":"1199 ORTEGA ST","applicant":"Eva\'s Catering","lot":"045","fooditems":"Cold Truck: Burrito: Corn Dog: Salads: Sandwiches: Quesadilla: Tacos: Fried Rice: Cow Mein: Chinese Rice: Noodle Plates: Soup: Bacon: Eggs: Ham: Avacado: Sausages: Beverages","longitude":"-122.4900712081","latitude":"37.7835091222127","objectid":"428005","y":"2113869.846","x":"5986602.689"},{"location":{"needs_recoding":false,"longitude":"-122.391181919056","latitude":"37.7881452962883"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0095","block":"3746","received":"Mar 25 2013  1:45PM","facilitytype":"Truck","blocklot":"3746002","locationdescription":"MAIN ST: FOLSOM ST to HARRISON ST (300 - 399)","cnn":"8630000","priorpermit":"1","approved":"2013-03-25T13:50:03","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0095&ExportPDF=1&Filename=13MFF-0095_schedule.pdf","address":"201 FOLSOM ST","applicant":"Paul\'s Catering","lot":"002","fooditems":"Cold Truck: Pre-packaged sandwiches: snacks: fruit: various beverages","longitude":"-122.391181919066","latitude":"37.7881452825154","objectid":"429417","y":"2114965.067","x":"6015208.504"},{"location":{"needs_recoding":false,"longitude":"-122.394629181652","latitude":"37.7806472238285"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0080","block":"3775","received":"Mar 15 2013  3:33PM","facilitytype":"Truck","blocklot":"3775025","locationdescription":"03RD ST: SOUTH PARK to VARNEY PL (548 - 586)","cnn":"177000","priorpermit":"0","approved":"2013-04-04T10:32:10","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0080&ExportPDF=1&Filename=13MFF-0080_schedule.pdf","address":"551 03RD ST","applicant":"Tacos El Ojo De Agua","lot":"025","fooditems":"Tacos: Burritos: Tortas: Quesadillas: Salads: Soup: Fruits: Juices: Soda: Water","longitude":"-122.394629181662","latitude":"37.7806472100484","objectid":"428037","y":"2112255.562","x":"6014157.282"},{"location":{"needs_recoding":false,"longitude":"-122.392982624218","latitude":"37.7870765441583"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0063","block":"3748","received":"Mar 14 2013  2:35PM","facilitytype":"Truck","blocklot":"3748007","locationdescription":"FREMONT ST: FOLSOM ST to HARRISON ST \\ I-80 W OFF RAMP (300 - 399)","cnn":"5864000","priorpermit":"1","approved":"2013-03-19T14:01:19","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0063&ExportPDF=1&Filename=13MFF-0063_schedule.pdf","address":"350 FREMONT ST","applicant":"Mini Mobile Food Catering","lot":"007","fooditems":"Cold Truck: Corn Dogs: Noodle Soups: Candy: Pre-packaged Snacks: Sandwiches: Chips: Coffee: Tea: Various Beverages","longitude":"-122.392982624228","latitude":"37.7870765303843","objectid":"427832","y":"2114586.51","x":"6014680.389"},{"location":{"needs_recoding":false,"longitude":"-122.412610953887","latitude":"37.7638066673242"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0096","block":"3968","received":"Mar 26 2013 10:15AM","facilitytype":"Truck","blocklot":"3968001","locationdescription":"ALABAMA ST: 17TH ST to MARIPOSA ST (400 - 499)","cnn":"2110000","priorpermit":"1","approved":"2013-03-26T10:19:07","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0096&ExportPDF=1&Filename=13MFF-0096_schedule.pdf","address":"400 ALABAMA ST","applicant":"M M Catering","lot":"001","fooditems":"Cold Truck: sandwiches: corndogs: tacos: yogurt: snacks: candy: hot and cold drinks","longitude":"-122.412610953897","latitude":"37.7638066535277","objectid":"429914","y":"2106230.541","x":"6008836.323"},{"location":{"needs_recoding":false,"longitude":"-122.389215559411","latitude":"37.7259305088731"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0105","block":"4831","received":"May  6 2013 10:50AM","facilitytype":"Truck","blocklot":"4831003","locationdescription":"JENNINGS ST: WALLACE AVE to YOSEMITE AVE (2200 - 2299)","cnn":"7480000","priorpermit":"1","approved":"2013-05-06T10:53:52","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0105&ExportPDF=1&Filename=13MFF-0105_schedule.pdf","address":"1495 WALLACE AVE","applicant":"Tacos El Primo","lot":"003","fooditems":"Mexican food: tacos: burritos: tortas: various meat and chicken and fish plate: chile relleno plate: fish plate: bread: flan: rice pudding: bread: fruit juice: vegetable juice: coffee: tea","longitude":"-122.389215559421","latitude":"37.7259304950399","objectid":"445254","y":"2092304.552","x":"6015319.326"},{"location":{"needs_recoding":false,"longitude":"-122.409573421614","latitude":"37.759796285523"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0057","block":"4080","received":"Mar 13 2013  2:15PM","facilitytype":"Truck","blocklot":"4080065","locationdescription":"BRYANT ST: 19TH ST to 20TH ST (2100 - 2199)","cnn":"3309000","priorpermit":"1","approved":"2013-03-13T14:46:23","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0057&ExportPDF=1&Filename=13MFF-0057_schedule.pdf","address":"2157 BRYANT ST","applicant":"John\'s Catering #5","lot":"065","fooditems":"Cold Truck: Soda:Chips:Candy: Cold/Hot Sandwiches: Donuts.  (Pitco Wholesale)","longitude":"-122.409573421624","latitude":"37.7597962717227","objectid":"427613","y":"2104752.654","x":"6009684.39"},{"location":{"needs_recoding":false,"longitude":"-122.384460244925","latitude":"37.7430142634481"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"13MFF-0072","block":"5203","received":"Mar 15 2013 10:24AM","facilitytype":"Truck","blocklot":"5203040","locationdescription":"NEWHALL ST: MENDELL ST to EVANS AVE (200 - 399)","cnn":"9563000","priorpermit":"1","approved":"2013-04-04T08:44:08","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=13MFF-0072&ExportPDF=1&Filename=13MFF-0072_schedule.pdf","address":"220 NEWHALL ST","applicant":"Park\'s Catering","lot":"040","fooditems":"Cold Truck: Hamburger: cheeseburgers: hot dogs: hot sandwiches: cold sandwiches: egg muffins: cup of noodles: corn dogs: canned soup: coffee: hot cocoa: hot tea: gatorade: juice: milk: soda: water: fruits: fruit salad: rice pudding: yogurt: candy bars: chips: cookies: donuts: granola bars: muffins","longitude":"-122.384460244935","latitude":"37.7430142496315","objectid":"427923","y":"2098496.079","x":"6016819.592"},{"location":{"needs_recoding":false,"longitude":"-122.400289778395","latitude":"37.7881050754192"},"status":"APPROVED","expirationdate":"2014-03-15T00:00:00","permit":"11MFF-0167","block":"3707","received":"Sep 12 2011 10:53AM","facilitytype":"Truck","blocklot":"3707011","locationdescription":"02ND ST: JESSIE ST to MISSION ST (69 - 99)","cnn":"131000","priorpermit":"0","approved":"2013-03-27T10:01:59","schedule":"http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=11MFF-0167&ExportPDF=1&Filename=11MFF-0167_schedule.pdf","address":"84 02ND ST","applicant":"Expresso Subito, LLC.","lot":"011","fooditems":"Espresso Drinks","longitude":"-122.400289778405","latitude":"37.7881050616463","objectid":"337108","y":"2115003.735","x":"6012576.846"}]'
  end

end
