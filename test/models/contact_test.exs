defmodule PhoenixAndElm.ContactTest do
  use PhoenixAndElm.ModelCase

  alias PhoenixAndElm.Contact

  @valid_attrs %{birth_date: %{day: 17, month: 4, year: 2010}, email: "some content", first_name: "some content", gender: 42, headline: "some content", last_name: "some content", location: "some content", phone_number: "some content", picture: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Contact.changeset(%Contact{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Contact.changeset(%Contact{}, @invalid_attrs)
    refute changeset.valid?
  end
end
