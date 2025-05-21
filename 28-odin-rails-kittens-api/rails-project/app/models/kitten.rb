class Kitten < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 50 }
  validates :age, presence: true, numericality: { 
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 30
  }
  validates :cuteness, presence: true, numericality: { 
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 10
  }
  validates :softness, presence: true, numericality: { 
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 10
  }
end
