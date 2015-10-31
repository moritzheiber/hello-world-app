#!/usr/bin/env ruby
require 'socket'
require 'webrick'

include WEBrick

s = HTTPServer.new(
  Port: 8000,
  DocumentRoot: "."
)

trap('TERM'){ s.shutdown }
s.start
