class Coctaile < ActiveRecord::Base

  has_many :ingredients
  has_many :products, through: :ingredients

  before_save { self.name = name.titleize }

  validates :name, presence: true, allow_blank: false

  validate :validate_coctaile_two
  #validate :validate_coctaile

  accepts_nested_attributes_for :ingredients,
    reject_if: lambda { |attributes|
       attributes[:value].blank? && attributes[:product_id].blank? }


  def validate_coctaile
    drink = 0
    ingredients.each do |ingredient|
      if ingredient.product.product_type == 'drink'
        drink = drink + 1
      else
      end
    end

    if drink < 1 || ingredients.size == 1
      errors.add(:name, " most have drink")
    end
  end

  def validate_coctaile_two
    drink = 0
    ingredients.select{ |ingredient|
      if ingredient.product.product_type == 'drink'
        drink = drink + 1
      end
    }
    if drink < 1 || ingredients.size == 1
      errors.add(:name, " most have drink")
    end
  end


  def value
   # ingredients.joins(:product).where('products.product_type = ?', 'drink').sum(:value)
    ingredients.inject(0) { |sum, ingredient|
      sum + (ingredient.product.product_type == 'drink' ? ingredient.value : 0)
    }
  end

  def price
  #  ingredients.all.inject(0) {
  #    |price, ingredient| price + ingredient.price
  # }

    ingredients.inject(0) { |price, ingredient|
      price + (ingredient.value / ingredient.product.min_value) *
        ingredient.product.price
    }
  end

end
