class Coctaile < ActiveRecord::Base

  has_many :ingredients
  has_many :products, through: :ingredients

  before_save { self.name = name.titleize }

  validates :name, presence: true, allow_blank: false

  validate :validate_coctaile

  accepts_nested_attributes_for :ingredients,
    reject_if: lambda { |attributes|
       attributes[:value].blank? && attributes[:product_id].blank? }

  def validate_coctaile
    drink = 0
    ingredients.select{ |ingredient|
      if ingredient.product.present?
        if ingredient.product.product_type == 'drink'
          drink = drink + 1
        end

        if ingredients.include? ingredient
          errors.add(:coctaile, " can't have equal products")
        end
      end
    }
    if drink < 1
      errors.add(:coctaile, " must have more drinks")
    end
    if ingredients.size == 1
      errors.add(:coctaile, " must have more ingredients")
    end
  end


  def value
    ingredients.inject(0) { |sum, ingredient|
      sum + (ingredient.product.product_type == 'drink' ? ingredient.value : 0)
    }
  end

  def price
    ingredients.inject(0) { |price, ingredient|
      price + (ingredient.value / ingredient.product.min_value) *
        ingredient.product.price
    }
  end


end
