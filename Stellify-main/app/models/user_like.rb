class UserLike < ApplicationRecord
  belongs_to :user
  belongs_to :likes, class_name: "User"
end
