class Group < ApplicationRecord
  belongs_to :owner, class_name: "User"

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
