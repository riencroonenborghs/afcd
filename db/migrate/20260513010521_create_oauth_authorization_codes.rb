# frozen_string_literal: true

class CreateOauthAuthorizationCodes < ActiveRecord::Migration[7.2]
  def change
    create_table :oauth_authorization_codes do |t|
      t.string :code, null: false
      t.integer :user_id, null: false
      t.integer :application_id, null: false
      t.datetime :expires_at, null: false
      t.boolean :used, null: false, default: false

      t.timestamps
    end
    add_index :oauth_authorization_codes, :code, unique: true
  end
end