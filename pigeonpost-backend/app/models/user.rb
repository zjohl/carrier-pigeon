class User < ApplicationRecord
  has_many :user_contacts
  has_many :contacts, through: :user_contacts, class_name: "User", dependent: :destroy

  validates :first_name, :last_name, :password, :email, presence: true
end