// import * as L from 'leaflet'
// import 'leaflet/dist/leaflet.css';
// import 'leaflet/dist/leaflet';
const polylineUtil = require('polyline-encoded');

const map = L.map('map').setView([51.505, -0.09], 13);
const exhibitionLayer = L.layerGroup();
map.addLayer(exhibitionLayer);

const defaultIcon = L.Icon.extend({
  options: {
    shadowUrl: "/images/markers/marker-shadow.png",
    iconSize: [55, 55],
    shadowSize: [49, 49],
    shadowAnchor: [15, 45],
    iconAnchor: [27, 53],
    popupAnchor: [0, -50]
  }
})
const unloadIcon = new defaultIcon({iconUrl: "/images/markers/marker-unload.png"})
const loadIcon = new defaultIcon({iconUrl: "/images/markers/marker-shopper.png"})
const driverIcon = new defaultIcon({iconUrl: "/images/markers/marker-driver.png"})

export function initMap() {
  L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
    maxZoom: 18,
    id: 'mapbox/streets-v11',
    tileSize: 512,
    zoomOffset: -1,
    accessToken: 'pk.eyJ1IjoiZ2FicmllbGZlcnJvIiwiYSI6ImNraGV4aHlrMzAyN2IycHFkZXM4NmlxOWsifQ.jX9lRWn2P1DvXvDR-98PhA'
}).addTo(map);
}

export function addRoute(route) {
  exhibitionLayer.clearLayers();
  const polyline = addPolyline(route.full_polyline);
  addMarker(route.driver_localization, "Driver", "<p>Driver</p>", driverIcon);
  addMarker(route.to_collect_localization, "Ponto de Coleta", "<p>Ponto de Coleta</p>", loadIcon);
  addMarker(route.to_deliver_localization, "Ponto de Entrega", "<p>Ponto de Entrega</p>", unloadIcon);
  focusOn(polyline);
}

export function addMarker(coordinates, title, html, icon) {
  let marker = L.marker(coordinates, {icon: icon}).addTo(exhibitionLayer);
  marker.bindPopup(html);
}

function focusOn(poly) {
  map.fitBounds(poly.getBounds());
}

export function addPolyline(polyline) {
  const decodedPolyline = polylineUtil.decode(polyline)
  const addedPoly = L.polyline(decodedPolyline, {color: 'red'}).addTo(exhibitionLayer);
  return addedPoly;
}