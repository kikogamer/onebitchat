class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.integer :team_id
      t.date :joined_date

      t.timestamps
    end
  end
end
