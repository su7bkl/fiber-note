class CreateBlocks < ActiveRecord::Migration[6.0]
  def change
    create_table :blocks, id: :uuid do |t|
      t.references :note, type: :uuid, null: false, foreign_key: true

      t.jsonb :content, null: false
      t.string :tags, array: true, default: [], index: { using: 'gin' }

      t.timestamps
    end
  end
end
