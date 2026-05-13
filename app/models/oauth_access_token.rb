# frozen_string_literal: true

# == Schema Information
#
# Table name: oauth_access_tokens
#
#  id                   :integer          not null, primary key
#  expires_at           :datetime
#  token                :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  oauth_application_id :integer          not null
#  user_id              :integer          not null
#
# Indexes
#
#  index_oauth_access_tokens_on_token  (token) UNIQUE
#
class OauthAccessToken < ApplicationRecord
  belongs_to :user
  belongs_to :oauth_application

  validates :token, presence: true, uniqueness: true

  before_validation :generate_token, on: :create

  scope :valid, -> { where("expires_at IS NULL OR expires_at > ?", Time.current) }

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  private

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(32)
  end
end
