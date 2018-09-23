class UserContact < ApplicationRecord
  validates :user_id, :contact_id, presence: true

  belongs_to :user
  belongs_to :contact, class_name: "User"


  after_create :create_inverse, unless: :has_inverse?
  after_destroy :destroy_inverses, if: :has_inverse?

  def create_inverse
    self.class.create(inverse_match_options)
  end

  def destroy_inverses
    inverses.destroy_all
  end

  def has_inverse?
    self.class.exists?(inverse_match_options)
  end

  def inverses
    self.class.where(inverse_match_options)
  end

  def inverse_match_options
    { contact_id: user_id, user_id: contact_id }
  end
end