# frozen_string_literal: true

class CreateOauthApplications < ActiveRecord::Migration[7.2]
  def change
    create_table :oauth_applications do |t|
      t.string :name, null: false
      t.string :client_id, null: false
      t.string :client_secret, null: false
      t.string :redirect_uri, null: false

      t.timestamps
    end
    add_index :oauth_applications, :client_id, unique: true
  end
end