class CreateUserLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :user_likes do |t|
      t.integer :user_id
      t.integer :likes_id

      t.timestamps
    end
  end
end
