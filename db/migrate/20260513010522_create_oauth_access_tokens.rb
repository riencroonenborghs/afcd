# frozen_string_literal: true

class CreateOauthAccessTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :oauth_access_tokens do |t|
      t.string :token, null: false
      t.integer :user_id, null: false
      t.integer :application_id, null: false
      t.datetime :expires_at

      t.timestamps
    end
    add_index :oauth_access_tokens, :token, unique: true
  end
end