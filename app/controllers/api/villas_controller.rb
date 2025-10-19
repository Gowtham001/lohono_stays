class Api::VillasController < ApplicationController
  before_action :validate_index_params, only: :index
  before_action :validate_availability_details_params, only: :availability_details
  before_action :validate_villa_presence, if: -> { params[:id].present? }

  def index
    @villas = fetch_villas
    render json: { villas: @villas, per_page: params[:per_page], page: params[:page], total: @villas.total_entries}
  end

  def availability_details
    render json: @villa.details(params[:from_date], params[:to_date])
  end

  private

  def validate_index_params
    @errors = []
    validate_from_date
    validate_to_date
    validate_sort_by
    validate_page_params
    render_errors
  end

  def validate_availability_details_params
    @errors = []
    validate_from_date
    validate_to_date
    render_errors
  end

  def validate_from_date
    if params[:from_date].present?
      unless valid_date?(params[:from_date])
        @errors << 'From date should be current/future date in %Y-%m-%d format'
      end
    else
      params[:from_date] = Date.today.to_s
    end
  end

  def validate_to_date
    if params[:to_date].present?
      unless valid_date?(params[:to_date])
        @errors << 'To date should be current/future date in %Y-%m-%d format'
      end

      if params[:from_date] > params[:to_date]
        @errors << 'To date should be greater than the from date'
      elsif params[:from_date] == params[:to_date]
        @errors << 'From date and to date cannot be same'
      end
    end
  end

  def validate_sort_by
    if params[:sort_by].present?
      unless params[:sort_by].to_s.in?(['price', 'date'])
        @errors << 'Sort by must be either price or date'
      end

      params[:sort_by] = { 'price' => 'avg_price',
                           'date'  => 'available_on' }[params[:sort_by]]
    else
      params[:sort_by] = 'available_on'
    end
  end

  def validate_page_params
    params[:page] = params[:page].to_i
    params[:per_page] = params[:per_page].to_i

    if !valid_number?(params[:page]) || params[:page] < 1
      params[:page] = 1
    end

    if !valid_number?(params[:per_page]) || params[:per_page] < 20 || params[:per_page] > 100
      params[:per_page] = 20
    end
  end

  def render_errors
    if @errors.present?
      render json: { message: @errors.join(', ') }, status: 422
    end
  end

  def valid_date?(date_string, format = '%Y-%m-%d')
    Date.strptime(date_string, format) >= Date.today
  rescue ArgumentError
    false
  end

  def valid_number?(number)
    number.to_s.match(/^(\d)+$/)
  end

  def validate_villa_presence
    @villa = Villa.find_by(id: params[:id])

    head 404 unless @villa
  end

  def fetch_villas
    @villas = Villa.joins(:calenders)
                   .where('available is TRUE AND stay_date >= ?', params[:from_date])
                   .group('villas.id, villas.name')

    if params[:name].present?
      @villas = @villas.where('name ilike ?', "%#{params[:name]}%")
    end

    if params[:to_date].present?
      @villas = @villas.where('stay_date < ?', params[:to_date])   
                       .having('count(*) = (DATE(?) - DATE(?))', params[:to_date], params[:from_date])
    end

    if params[:sort_by].present?
      @villas = @villas.order(params[:sort_by]) 
    end

    @villas.paginate(per_page: params[:per_page], page: params[:page])
           .select('villas.id,
                    villas.name,
                    AVG(price) avg_price,
                    (ARRAY_AGG(stay_date order by stay_date))[1:10] available_on')
  end
end