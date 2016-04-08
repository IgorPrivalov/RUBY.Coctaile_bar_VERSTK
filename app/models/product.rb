class Product < ActiveRecord::Base

  @@product_types = ['drink', 'not drink']

  def self.product_types
    @@product_types
  end



end
