class Coctaile < ActiveRecord::Base

  has_many :ingredients
  has_many :products, through: :ingredients

  before_save { self.name = name.titleize }

  validates :name, presence: true, allow_blank: false

  accepts_nested_attributes_for :ingredients,
    reject_if: lambda { |attributes|
       attributes[:value].blank? && attributes[:product_id].blank? }

  def value
    ingredients.joins(:product).where('products.product_type = ?', 'drink').sum(:value)
  end

  def price
    ingredients.all.inject(0) {
      |price, ingredient| price + ingredient.price
    }
  end

end
