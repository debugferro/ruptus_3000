// import * as L from 'leaflet'
// import 'leaflet/dist/leaflet.css';
// import 'leaflet/dist/leaflet';
const polylineUtil = require('polyline-encoded');

export function initMap() {
  const map = L.map('map').setView([51.505, -0.09], 13);
  L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
    maxZoom: 18,
    id: 'mapbox/streets-v11',
    tileSize: 512,
    zoomOffset: -1,
    accessToken: 'pk.eyJ1IjoiZ2FicmllbGZlcnJvIiwiYSI6ImNraGV4aHlrMzAyN2IycHFkZXM4NmlxOWsifQ.jX9lRWn2P1DvXvDR-98PhA'
}).addTo(map);
}

export function addPolyline(polyline) {
  const map = L.map('map')

}