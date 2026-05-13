# frozen_string_literal: true

# == Schema Information
#
# Table name: oauth_authorization_codes
#
#  id                   :integer          not null, primary key
#  code                 :string           not null
#  expires_at           :datetime         not null
#  used                 :boolean          default(FALSE), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  oauth_application_id :integer          not null
#  user_id              :integer          not null
#
# Indexes
#
#  index_oauth_authorization_codes_on_code  (code) UNIQUE
#
class OauthAuthorizationCode < ApplicationRecord
  belongs_to :user
  belongs_to :oauth_application

  validates :code, :expires_at, presence: true
  validates :code, uniqueness: true

  before_validation :generate_code, on: :create

  scope :valid, -> { where(used: false).where("expires_at > ?", Time.current) }

  def expired?
    expires_at < Time.current
  end

  def consume!
    update!(used: true)
  end

  private

  def generate_code
    self.code ||= SecureRandom.urlsafe_base64(32)
    self.expires_at ||= 10.minutes.from_now
  end
end
