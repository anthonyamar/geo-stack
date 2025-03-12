import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  static targets = [
    "locations", 
    "zoomLevel",
    "diveCenterMarkerUrl", 
    "diveSiteMarkerUrl",
    "destinationMarkerUrl",
    "mapboxToken"
  ]
  
  static values = {
    locations: Object,
    zoomLevel: Number,
    diveCenterMarkerUrl: String,
    diveSiteMarkerUrl: String,
    destinationMarkerUrl: String,
    mapboxToken: String
  }

  connect() {
    const locations = JSON.parse(this.data.get("locations"));
    this.initializeMap(locations);
  }

  initializeMap(locations) {
    this.map = L.map('map');
    this.map.setView(
      [locations[0].latitude, locations[0].longitude], 
      this.data.get("zoomLevel")
    );
    
    L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}&language=en', {
      maxZoom: 19,
      id: 'anthonyamar/cloov0uiv00h401pl238geunu', // ou un autre style de carte de votre choix
      accessToken: this.data.get("mapboxToken"),
      attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, ' +
        '<a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
        'Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
      language: 'en' // Définir la langue des étiquettes en anglais
    }).addTo(this.map);

    for (var i = 0; i < locations.length; i++) {
      var marker = L.marker([locations[i].latitude, locations[i].longitude], {
        icon: this.marker(locations[i].type),
      }).addTo(this.map);

      marker.bindPopup(locations[i].popup);
      (i == 0) && marker.openPopup(); 
    }
  }

  findPopupByCoordinates(map, latlng) {
    let targetPopup = null;

    // Utilisez eachLayer pour parcourir tous les calques de la carte
    map.eachLayer((layer) => {
      // Vérifiez si le calque est un popup et si ses coordonnées correspondent
      console.log(layer)
      if (layer instanceof L.Popup && layer.getLatLng().equals(latlng)) {
        targetPopup = layer;
      }
    });
    
    return targetPopup;
  }
  
  // Bouge la map au point souhaité sur event (clic ou autres), puis ouvre le popup
  setCenter({ params: {latitude, longitude} }) { 
    const coordinates = [latitude, longitude]
    const popup = this.findPopupByCoordinates(this.map, coordinates); // OUTPUT NULL
    
    this.map.panTo(coordinates, 15);
    console.log(popup) // DON'T WORK
    popup.openPopup(); // DON'T WORK 
  }

  // Donne le marker approprié
  marker(type) {
   const iconUrls = {
      "dive_site": this.data.get("diveSiteMarkerUrl"),
      "dive_center": this.data.get("diveCenterMarkerUrl"),
      "destination": this.data.get("destinationMarkerUrl")
    };

    var iconUrl = iconUrls[type] || this.data.get("destinationMarkerUrl"); // Fallback to a destination as default if needed

    return L.icon({
      iconUrl: iconUrl,
      iconSize: [38, 38],
    })
  }
};
