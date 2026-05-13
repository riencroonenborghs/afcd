# frozen_string_literal: true

# == Schema Information
#
# Table name: oauth_applications
#
#  id            :integer          not null, primary key
#  client_secret :string           not null
#  name          :string           not null
#  redirect_uri  :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  client_id     :string           not null
#
# Indexes
#
#  index_oauth_applications_on_client_id  (client_id) UNIQUE
#
class OauthApplication < ApplicationRecord
  has_many :oauth_access_tokens, dependent: :destroy
  has_many :oauth_authorization_codes, dependent: :destroy

  validates :name, :client_id, :client_secret, :redirect_uri, presence: true
  validates :client_id, uniqueness: true

  before_validation :generate_credentials, on: :create

  def redirect_uri_valid?(uri)
    redirect_uri == uri
  end

  private

  def generate_credentials
    self.client_id ||= SecureRandom.hex(16)
    self.client_secret ||= SecureRandom.hex(32)
  end
end
