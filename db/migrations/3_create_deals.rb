Sequel.migration do
  change do
    create_table(:deals) do
      column :id, :uuid, :default => Sequel.function(:uuid_generate_v4), :primary_key => true
      column :type, String
      column :a, :uuid
      column :b, :uuid
      column :money, Integer, null: false
      column :description, String
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end
end
