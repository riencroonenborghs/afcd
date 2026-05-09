# frozen_string_literal: true

class AddFts5FoodsSearch < ActiveRecord::Migration[7.2]
  def up
    execute <<~SQL
      CREATE VIRTUAL TABLE foods_fts USING fts5(
        food_name,
        content=foods,
        content_rowid=id,
        tokenize='unicode61 remove_diacritics 1'
      );
    SQL

    execute "INSERT INTO foods_fts(rowid, food_name) SELECT id, food_name FROM foods;"

    execute <<~SQL
      CREATE TRIGGER foods_ai AFTER INSERT ON foods BEGIN
        INSERT INTO foods_fts(rowid, food_name) VALUES (new.id, new.food_name);
      END;
    SQL

    execute <<~SQL
      CREATE TRIGGER foods_ad AFTER DELETE ON foods BEGIN
        INSERT INTO foods_fts(foods_fts, rowid, food_name) VALUES ('delete', old.id, old.food_name);
      END;
    SQL

    execute <<~SQL
      CREATE TRIGGER foods_au AFTER UPDATE ON foods BEGIN
        INSERT INTO foods_fts(foods_fts, rowid, food_name) VALUES ('delete', old.id, old.food_name);
        INSERT INTO foods_fts(rowid, food_name) VALUES (new.id, new.food_name);
      END;
    SQL
  end

  def down
    execute "DROP TRIGGER IF EXISTS foods_au;"
    execute "DROP TRIGGER IF EXISTS foods_ad;"
    execute "DROP TRIGGER IF EXISTS foods_ai;"
    execute "DROP TABLE IF EXISTS foods_fts;"
  end
end