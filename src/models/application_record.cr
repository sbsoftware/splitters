abstract class ApplicationRecord < Orma::Record
  macro inherited
    id_column id : Int64
  end

  def self.db_connection_string
    "sqlite3://./data.db"
  end
end
