class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  def password_required?
    false
  end

  has_many :liked_users, foreign_key: :user_id, class_name: "UserLike"
  has_many :likes, through: :liked_users, dependent: :delete_all

  def self.from_twitch(username, email)
    user = User.find_by(email: email)
    user = User.create!(username: username, email: email) unless user

    user
  end
end
