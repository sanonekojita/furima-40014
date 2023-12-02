class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname, presence: true
  validates :birth_date, presence: true

  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i
  validates_format_of :password, with: PASSWORD_REGEX, message: 'is invalid. Include both letters and numbers'

  validates :last_name, presence: true
  LAST_NAME_REGEX = /\A[ぁ-んァ-ヶ一-龥々ー]+\z/
  validates_format_of :last_name, with: LAST_NAME_REGEX, message: 'is invalid. Input full-width characters'

  validates :first_name, presence: true
  FIRST_NAME_REGEX = /\A[ぁ-んァ-ヶ一-龥々ー]+\z/
  validates_format_of :first_name, with: FIRST_NAME_REGEX, message: 'is invalid. Input full-width characters'

  validates :last_name_kana, presence: true
  LAST_NAME_KANA_REGEX = /\A[ァ-ヶー－]+\z/
  validates_format_of :last_name_kana, with: LAST_NAME_KANA_REGEX, message: 'is invalid. Input full-width katakana characters'

  validates :first_name_kana, presence: true
  FIRST_NAME_KANA_REGEX = /\A[ァ-ヶー－]+\z/
  validates_format_of :first_name_kana, with: FIRST_NAME_KANA_REGEX, message: 'is invalid. Input full-width katakana characters'
end
