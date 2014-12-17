class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  # for later: :registerable,
  devise :ldap_authenticatable, :recoverable, :rememberable, :trackable, :validatable
end
