@map = window.map = null

Map = React.createClass
  propTypes:
    center: React.PropTypes.array,
    zoom: React.PropTypes.number,
    onMapHandlers: React.PropTypes.object,
    features: React.PropTypes.array,
    featuresStyle: React.PropTypes.object,
    featuresHighlightedStyle: React.PropTypes.object,
    onFeatureHandlers: React.PropTypes.object,
    markers: React.PropTypes.array,
    pathLines: React.PropTypes.bool,
    pathLinesStyle: React.PropTypes.object,
    onMarkerHandlers: React.PropTypes.object,
    setFocusOnLastMarker: React.PropTypes.bool,
    markerDraggingEnable: React.PropTypes.bool

  getInitialState: ->
    {
    markerIcon: L.icon({
      iconUrl: '/assets/icons/marker_icon.png',
      iconSize:     [40, 50],
      iconAnchor:   [20, 50],
      popupAnchor:  [1, -40]
    })
    }

  getDefaultProps: ->
    {
    center: [20, 10],
    zoom: 2,
    onMapHandlers: {},
    features: [],
    featuresStyle: {
      color: '#ED9355',
      fillOpacity: 0.7,
      weight: 0.1,
      opacity: 0.7
    },
    featuresHighlightedStyle: {
      color: '#ED9355',
      fillOpacity: 0.9,
      weight: 0.1,
      opacity: 0.4
    },
    onFeatureHandlers: {},
    markers: [],
    pathLines: false,
    pathLinesStyle: {
      color: '#84BEAF',
      weight: 2,
      opacity: 0.7
    },
    onMarkerHandlers: {},
    setFocusOnLastMarker: false,
    markerDraggingEnable: false
    }

  componentDidMount: ->
    window.map = window.map = L.map(@getDOMNode(),{
      layers: MQ.mapLayer(),
      center: @props.center,
      zoom: @props.zoom
    }).setView(@props.center, @props.zoom)

    handlers = {}
    for k, v of @props.onMapHandlers
      handlers[k] = v
    window.map.on(handlers)

    L.geoJson(@props.features, {
      style: @props.featuresStyle,
      onEachFeature: (feature, layer) =>
        handlers = {
          mouseover: (e) =>
            e.target.setStyle @props.featuresHighlightedStyle
            e.target.bringToFront() if (!L.Browser.ie and !L.Browser.opera)
          mouseout: (e) =>
            e.target.setStyle @props.featuresStyle
            e.target.bringToFront() if (!L.Browser.ie and !L.Browser.opera)
        }
        for k, v of @props.onFeatureHandlers
          handlers[k] = v
        layer.on(handlers)
    }).addTo(window.map)

    handlers = {}
    paths = []
    for m in @props.markers
      marker = L.marker(m, {icon:@state.markerIcon, id: (m.id if m.id?), timestamp: (m.timestamp if m.timestamp?), marker: (m.marker if m.marker?)}).addTo(window.map)
      marker.dragging.enable() if @props.markerDraggingEnable
      paths.push marker.getLatLng() if @props.pathLines
      for k, v of @props.onMarkerHandlers
        handlers[k] = v
      marker.on(handlers)

    if @props.markers.length > 0 && @props.setFocusOnLastMarker
      last_marker = @props.markers[0]
      window.map.setView [last_marker.lat, last_marker.lng], 15

    if paths.length > 0
      L.polyline(paths, @props.pathLinesStyle).addTo(window.map)

  render: -> `<div id='map'></div>`

@mapInstance = (options) ->
  React.createElement(Map, options)