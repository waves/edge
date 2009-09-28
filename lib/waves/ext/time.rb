class Time
  def to_http_timestamp
    clone.gmtime.strftime("%a, %d-%b-%Y %H:%M:%S GMT")
  end
end