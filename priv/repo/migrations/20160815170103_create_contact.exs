defmodule PhoenixAndElm.Repo.Migrations.CreateContact do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :gender, :integer, default: 0
      add :birth_date, :date, null: false
      add :location, :string, null: false
      add :phone_number, :string
      add :email, :string, null: false
      add :headline, :text
      add :picture, :string

      timestamps()
    end
  end
end
