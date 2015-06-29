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
    pathLines: React.PropTypes.array,
    pathLinesStyle: React.PropTypes.object,
    onMarkerHandlers: React.PropTypes.object

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
    pathLines: [],
    pathLinesStyle: {
      color: '#84BEAF',
      weight: 2,
      opacity: 0.7
    },
    onMarkerHandlers: {}
    }

  componentDidMount: ->
    map = @map = L.map(@getDOMNode(),{
      layers: MQ.mapLayer(),
      center: @props.center,
      zoom: @props.zoom
    }).setView(@props.center, @props.zoom)
    handlers = {}
    for k, v of @props.onMapHandlers
      handlers[k] = v
    map.on(handlers)

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
    }).addTo(@map)

    handlers = {}
    for latLng in @props.markers
      marker = L.marker(latLng, {icon:@state.markerIcon}).addTo(@map)
      for k, v of @props.onMarkerHandlers
        handlers[k] = v
      marker.on(handlers)

    if @props.markers.length > 0
      last_marker = @props.markers[0]
      @map.setView [last_marker.lat, last_marker.lng], 15

    for line in @props.pathLines
      L.geoJson(line, {style:@props.pathLinesStyle}).addTo(@map)

  render: -> `<div id='map'></div>`

@mapInstance = (options) ->
  React.createElement(Map, options)