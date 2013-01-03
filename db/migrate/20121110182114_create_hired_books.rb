class CreateHiredBooks < ActiveRecord::Migration
  def change
    create_table :hired_books do |t|
      t.integer :book_id
      t.date :expiration_time
      t.integer :user_id

      t.timestamps
    end
  end
end
