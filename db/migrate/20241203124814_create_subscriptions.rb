class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.references :customer, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :outstanding_balance, precision: 10, scale: 2, default: 0.0
      t.timestamps
    end
  end
end