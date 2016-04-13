class Ingredient < ActiveRecord::Base

  belongs_to :coctaile
  belongs_to :product

  def price
    (value / product.min_value) * product.price
  end

end
