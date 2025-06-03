require "sqlite3"
require "crumble"
require "crumble-material"
require "crumble-turbo"
require "./ext/**"
require "./macros"
require "./models/*"
require "./styles/*"
require "./js/**"
require "./views/**"
require "./resources/*"

Crumble::Server.start
