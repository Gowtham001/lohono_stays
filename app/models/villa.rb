class Villa < ApplicationRecord
  has_many :calenders

  def details(from_date, to_date)
    from_date ||= Date.today.to_s
    to_date   ||= (Date.today + 90).to_s
    cal_data    = calenders.available_between(from_date, to_date).pluck(:stay_date, :price)
    total_price = cal_data.sum { _1.second }

    {
        name:,
        available_all_days: cal_data.count == (Date.strptime(to_date) - Date.strptime(from_date)),
        available_on: cal_data.map { { date: _1.first, price: _1.second } },   
        total_price: total_price + (total_price*0.18),
    }
  end
end
