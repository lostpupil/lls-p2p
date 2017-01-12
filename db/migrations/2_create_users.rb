Sequel.migration do
  change do
    create_table(:users) do
      column :id, :uuid, :default => Sequel.function(:uuid_generate_v4), :primary_key => true
      column :username, String, null: false, limit: 255, unique: true
      column :encrypted_password, String, null: false, limit: 255
      column :money, Integer, default: 0
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end
end
