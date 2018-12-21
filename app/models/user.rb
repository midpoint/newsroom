class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :rememberable,
    :omniauthable, omniauth_providers: %i[github]

  validates :username, presence: true
  validates :email, presence: true

  validates :github_id, presence: true
  validates :github_token, presence: true
end
