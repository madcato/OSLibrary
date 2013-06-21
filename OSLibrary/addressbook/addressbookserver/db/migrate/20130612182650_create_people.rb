class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.boolean :programmer
      t.float :height
      t.timestamp :birthDate
      t.binary :avatar

      t.timestamps
    end
  end
end
