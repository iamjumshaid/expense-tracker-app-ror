class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :accounts, dependent: :destroy
  has_one :wallet, dependent: :destroy
  has_many :transactions, dependent: :destroy

  enum role: [:standard, :premium, :admin]


  after_initialize do
  if self.new_record?
    self.role ||= :standard
  end
end
end
