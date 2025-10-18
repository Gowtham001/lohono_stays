class Villa < ApplicationRecord
  has_many :calenders

  def details(from_date = Date.today, to_date = Date.today + 30)
    cal_data = calenders.available_between(from_date, to_date).pluck(:stay_date, :price)
    total_price = cal_data.sum { _1.second }

    {
        name:,
        available: cal_data.count == (Date.strptime(to_date) - Date.strptime(from_date)) - 1,
        available_on: cal_data.map { { date: _1.first, price: _1.second } },   
        total_price: total_price + (total_price*0.18),
    }
  end
end
