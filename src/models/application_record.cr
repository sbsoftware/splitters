class ApplicationRecord < Orma::Record
  id_column id : Int64

  def self.db_connection_string
    "sqlite3://./data.db"
  end
end
