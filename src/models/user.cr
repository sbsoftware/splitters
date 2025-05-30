require "./application_record"

class User < ApplicationRecord
  column name : String?
  column created_at : Time
  column updated_at : Time
end
