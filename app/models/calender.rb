class Calender < ApplicationRecord
  belongs_to :villa

  scope :available_between, ->(from_date, to_date) {
    where('available is TRUE and stay_date >= ? and stay_date < ?', from_date, to_date)
  }
end
