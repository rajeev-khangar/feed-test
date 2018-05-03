class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.text :url
      t.text :link
      t.integer :likes_count
      t.integer :tags_count
      t.integer :comments_count
      t.string :instagram_post_id

      t.timestamps
    end
  end
end
