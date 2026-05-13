# frozen_string_literal: true

class RenameApplicationIdColumns < ActiveRecord::Migration[7.2]
  def change
    rename_column :oauth_access_tokens, :application_id, :oauth_application_id
    rename_column :oauth_authorization_codes, :application_id, :oauth_application_id
  end
end
