class Product < ActiveRecord::Base

  validates :name, :cost_price, :min_value, :product_type, presence: true

  validates :cost_price, :min_value, numericality: {:greater_than => 0}

  has_many :ingredients

  @@tax = 0.04
  @@markup_percent = 0.5

  @@product_types = ['drink', 'not drink']

  def price
    cost_price + markup + (markup * @@tax)
  end

  def markup
    cost_price * @@markup_percent
  end

  def self.product_types
    @@product_types
  end

end