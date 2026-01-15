require "spec"
require "crumble"

ENV["DATABASE_URL"] ||= "sqlite3::memory:"
ENV["ORMA_CONTINUOUS_MIGRATION"] ||= "true"

require "../src/environment"

module SpecDB
  @@db : DB::Database?

  def self.db
    @@db ||= DB.open(ENV["DATABASE_URL"])
  end
end

abstract class Orma::Record
  def self.db
    if conn = Fiber.current._orma_current_connection
      return conn
    end

    SpecDB.db
  end
end
