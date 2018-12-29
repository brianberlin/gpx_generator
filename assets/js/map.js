import {Socket} from 'phoenix'

const socket = new Socket('/socket')
socket.connect()

const channel = socket.channel('map', {})

channel.join()

function updateGpx({data}) {
  document.querySelector('.gpx').value = data
}

channel.on('points', updateGpx)

const map = new google.maps.Map(document.querySelector('.map'), {
  center: {lat: -34.397, lng: 150.644},
  zoom: 16
});

const markers = new google.maps.MVCArray()
const polyline = new google.maps.Polyline({ map })

map.addListener('click', function (event) {
  markers.push(event.latLng)
  update()
})

function update() {
  polyline.setPath(markers)
  const points = markers.getArray().map(({lat, lng}) => {
    return [lat(), lng()]
  })
  channel.push('points', points).receive('ok', updateGpx)
}


function setPosition(position) {
  var pos = {
    lat: position.coords.latitude,
    lng: position.coords.longitude
  };
  map.setCenter(pos);
}

const removeBtn = document.querySelector('[data-remove]')

removeBtn.addEventListener('click', (element) => {
  markers.pop()
  update()
})


navigator.geolocation.getCurrentPosition(setPosition)

