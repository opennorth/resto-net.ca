$.fn.popover.Constructor.prototype.setContent = ->
    $tip = @tip()
    $tip.find('.popover-title').html @getTitle()
    $tip.find('.popover-content').html @getContent()
    $tip.removeClass 'fade top bottom left right in'

I18n =
  en:
    tweet_text: 'Hey @resto_net, please make %{city} your next city. cc @opennorth'
    tweet_related: 'opennorth'
  fr:
    tweet_text: 'Hé @resto_net, svp ajouter prochainement la ville de %{city}. cc @opennorth'
    tweet_related: 'nordouvert'

t = (string, args = {}) ->
  current_locale = args.locale or locale
  string = I18n[current_locale][string] or string
  string = string.replace ///%\{#{key}\}///g, value for key, value of args
  string

$ ->
  $('a[rel=popover]').popover
    template: '<div class="popover"><div class="arrow"></div><div class="popover-inner"><blockquote><p class="popover-content"></p><small class="popover-title"></small></blockquote></div></div>'

  if center? and zoom? and bounds?
    map = new L.Map('map', {
      center: center,
      zoom: zoom,
      layers: [
        new L.TileLayer('http://{s}.tile.cloudmade.com/266d579a42a943a78166a0a732729463/51080/256/{z}/{x}/{y}.png', {
          attribution: '© 2011 <a href="http://cloudmade.com/">CloudMade</a> – Map data <a href="http://creativecommons.org/licenses/by-sa/2.0/">CCBYSA</a> 2011 <a href="http://openstreetmap.org/">OpenStreetMap.org</a> – <a href="http://cloudmade.com/about/api-terms-and-conditions">Terms of Use</a>'
        })
      ],
      maxZoom: 17
    });
    # @todo geolocate (check if in bounds), add markers


  $('#twitter').submit (e) ->
    city = $('#twitter input').val()
    if city isnt '' and city isnt 'my city'
      window.open("http://twitter.com/share?url=#{encodeURIComponent 'http://resto-net.ca/'}&text=#{encodeURIComponent t('tweet_text', city: city)}&related=resto_net,#{t 'tweet_related'}&lang=#{locale}", 'intent', 'width=550,height=450');
    e.preventDefault()

  if latlng?
    map = new L.Map 'mini-map',
      center: latlng
      zoom: 16
      layers: [
        new L.TileLayer 'http://{s}.tile.cloudmade.com/266d579a42a943a78166a0a732729463/51080/256/{z}/{x}/{y}.png',
          attribution: '© <a href="http://cloudmade.com/">CloudMade</a> – <a href="http://creativecommons.org/licenses/by-sa/2.0/">CCBYSA</a> <a href="http://openstreetmap.org/">OpenStreetMap.org</a> – <a href="http://cloudmade.com/about/api-terms-and-conditions">Terms</a>'
      ]
      minZoom: 10
      maxZoom: 18
    map.attributionControl.setPrefix null
    map.addLayer new L.Marker latlng
