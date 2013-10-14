class CreateContentBlobs < ActiveRecord::Migration
  def self.up
    create_table :content_blobs do |t|
      t.integer  "blobable_id"
      t.string   "blobable_type"
      t.text     "contents",       :limit => 2147483647
      t.timestamps
    end

    add_index :content_blobs, [:blobable_type, :blobable_id]
  end

  def self.down
    drop_table :content_blobs
  end
end
