Geocoder.configure(
  # street address geocoding service (default :nominatim)
  #  lookup: :yandex,

  # IP address geocoding service (default :ipinfo_io)
  ip_lookup: :maxmind,

  # geocoding service request timeout, in seconds (default 3):
  timeout: 1,

  # set default units to kilometers:
  units: :km

  # caching (see Caching section below for details):
  #  cache: Redis.new,
  #  cache_options: {
  #    expiration: 1.day, # Defaults to `nil`
  #    prefix: "another_key:" # Defaults to `geocoder:`
  #  }
)
