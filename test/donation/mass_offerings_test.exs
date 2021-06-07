defmodule Donation.MassOfferingsTest do
  use Donation.DataCase

  alias Donation.MassOfferings

  describe "mass_offerings" do
    alias Donation.MassOfferings.MassOffering

    @valid_attrs %{contact_name: "some contact_name", contact_number: "some contact_number", email_address: "some email_address"}
    @update_attrs %{contact_name: "some updated contact_name", contact_number: "some updated contact_number", email_address: "some updated email_address"}
    @invalid_attrs %{contact_name: nil, contact_number: nil, email_address: nil}

    def mass_offering_fixture(attrs \\ %{}) do
      {:ok, mass_offering} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MassOfferings.create_mass_offering()

      mass_offering
    end

    test "list_mass_offerings/0 returns all mass_offerings" do
      mass_offering = mass_offering_fixture()
      assert MassOfferings.list_mass_offerings() == [mass_offering]
    end

    test "get_mass_offering!/1 returns the mass_offering with given id" do
      mass_offering = mass_offering_fixture()
      assert MassOfferings.get_mass_offering!(mass_offering.id) == mass_offering
    end

    test "create_mass_offering/1 with valid data creates a mass_offering" do
      assert {:ok, %MassOffering{} = mass_offering} = MassOfferings.create_mass_offering(@valid_attrs)
      assert mass_offering.contact_name == "some contact_name"
      assert mass_offering.contact_number == "some contact_number"
      assert mass_offering.email_address == "some email_address"
    end

    test "create_mass_offering/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MassOfferings.create_mass_offering(@invalid_attrs)
    end

    test "update_mass_offering/2 with valid data updates the mass_offering" do
      mass_offering = mass_offering_fixture()
      assert {:ok, %MassOffering{} = mass_offering} = MassOfferings.update_mass_offering(mass_offering, @update_attrs)
      assert mass_offering.contact_name == "some updated contact_name"
      assert mass_offering.contact_number == "some updated contact_number"
      assert mass_offering.email_address == "some updated email_address"
    end

    test "update_mass_offering/2 with invalid data returns error changeset" do
      mass_offering = mass_offering_fixture()
      assert {:error, %Ecto.Changeset{}} = MassOfferings.update_mass_offering(mass_offering, @invalid_attrs)
      assert mass_offering == MassOfferings.get_mass_offering!(mass_offering.id)
    end

    test "delete_mass_offering/1 deletes the mass_offering" do
      mass_offering = mass_offering_fixture()
      assert {:ok, %MassOffering{}} = MassOfferings.delete_mass_offering(mass_offering)
      assert_raise Ecto.NoResultsError, fn -> MassOfferings.get_mass_offering!(mass_offering.id) end
    end

    test "change_mass_offering/1 returns a mass_offering changeset" do
      mass_offering = mass_offering_fixture()
      assert %Ecto.Changeset{} = MassOfferings.change_mass_offering(mass_offering)
    end
  end

  describe "mass_offering_items" do
    alias Donation.MassOfferings.MassOfferingItem

    @valid_attrs %{intention: "some intention", number_of_mass: 42, specific_dates: ~D[2010-04-17], to_whom: "some to_whom", type_of_mass: "some type_of_mass"}
    @update_attrs %{intention: "some updated intention", number_of_mass: 43, specific_dates: ~D[2011-05-18], to_whom: "some updated to_whom", type_of_mass: "some updated type_of_mass"}
    @invalid_attrs %{intention: nil, number_of_mass: nil, specific_dates: nil, to_whom: nil, type_of_mass: nil}

    def mass_offering_item_fixture(attrs \\ %{}) do
      {:ok, mass_offering_item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MassOfferings.create_mass_offering_item()

      mass_offering_item
    end

    test "list_mass_offering_items/0 returns all mass_offering_items" do
      mass_offering_item = mass_offering_item_fixture()
      assert MassOfferings.list_mass_offering_items() == [mass_offering_item]
    end

    test "get_mass_offering_item!/1 returns the mass_offering_item with given id" do
      mass_offering_item = mass_offering_item_fixture()
      assert MassOfferings.get_mass_offering_item!(mass_offering_item.id) == mass_offering_item
    end

    test "create_mass_offering_item/1 with valid data creates a mass_offering_item" do
      assert {:ok, %MassOfferingItem{} = mass_offering_item} = MassOfferings.create_mass_offering_item(@valid_attrs)
      assert mass_offering_item.intention == "some intention"
      assert mass_offering_item.number_of_mass == 42
      assert mass_offering_item.specific_dates == ~D[2010-04-17]
      assert mass_offering_item.to_whom == "some to_whom"
      assert mass_offering_item.type_of_mass == "some type_of_mass"
    end

    test "create_mass_offering_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MassOfferings.create_mass_offering_item(@invalid_attrs)
    end

    test "update_mass_offering_item/2 with valid data updates the mass_offering_item" do
      mass_offering_item = mass_offering_item_fixture()
      assert {:ok, %MassOfferingItem{} = mass_offering_item} = MassOfferings.update_mass_offering_item(mass_offering_item, @update_attrs)
      assert mass_offering_item.intention == "some updated intention"
      assert mass_offering_item.number_of_mass == 43
      assert mass_offering_item.specific_dates == ~D[2011-05-18]
      assert mass_offering_item.to_whom == "some updated to_whom"
      assert mass_offering_item.type_of_mass == "some updated type_of_mass"
    end

    test "update_mass_offering_item/2 with invalid data returns error changeset" do
      mass_offering_item = mass_offering_item_fixture()
      assert {:error, %Ecto.Changeset{}} = MassOfferings.update_mass_offering_item(mass_offering_item, @invalid_attrs)
      assert mass_offering_item == MassOfferings.get_mass_offering_item!(mass_offering_item.id)
    end

    test "delete_mass_offering_item/1 deletes the mass_offering_item" do
      mass_offering_item = mass_offering_item_fixture()
      assert {:ok, %MassOfferingItem{}} = MassOfferings.delete_mass_offering_item(mass_offering_item)
      assert_raise Ecto.NoResultsError, fn -> MassOfferings.get_mass_offering_item!(mass_offering_item.id) end
    end

    test "change_mass_offering_item/1 returns a mass_offering_item changeset" do
      mass_offering_item = mass_offering_item_fixture()
      assert %Ecto.Changeset{} = MassOfferings.change_mass_offering_item(mass_offering_item)
    end
  end
end
