# Fact Type Model
class FactType < ActiveRecord::Base
  include TagMethods

  before_create :set_default_values
  before_save :normalize_input
  before_destroy :check_for_posts

  # Validations
  validates_uniqueness_of :name

  # Attributes Length Validations
  validates :name, length: {minimum: 4}
  validates :name, length: {maximum: 15}

  # Relationships
  has_many :posts
end
