defmodule Fileonchain.CidsTest do
  use Fileonchain.DataCase

  alias Fileonchain.Cids

  describe "cids" do
    alias Fileonchain.Cids.Cid

    import Fileonchain.CidsFixtures

    @invalid_attrs %{data: nil, cid: nil}

    test "list_cids/0 returns all cids" do
      cid = cid_fixture()
      assert Cids.list_cids() == [cid]
    end

    test "get_cid!/1 returns the cid with given id" do
      cid = cid_fixture()
      assert Cids.get_cid!(cid.id) == cid
    end

    test "create_cid/1 with valid data creates a cid" do
      valid_attrs = %{data: "some data", cid: "some cid"}

      assert {:ok, %Cid{} = cid} = Cids.create_cid(valid_attrs)
      assert cid.data == "some data"
      assert cid.cid == "some cid"
    end

    test "create_cid/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cids.create_cid(@invalid_attrs)
    end

    test "update_cid/2 with valid data updates the cid" do
      cid = cid_fixture()
      update_attrs = %{data: "some updated data", cid: "some updated cid"}

      assert {:ok, %Cid{} = cid} = Cids.update_cid(cid, update_attrs)
      assert cid.data == "some updated data"
      assert cid.cid == "some updated cid"
    end

    test "update_cid/2 with invalid data returns error changeset" do
      cid = cid_fixture()
      assert {:error, %Ecto.Changeset{}} = Cids.update_cid(cid, @invalid_attrs)
      assert cid == Cids.get_cid!(cid.id)
    end

    test "delete_cid/1 deletes the cid" do
      cid = cid_fixture()
      assert {:ok, %Cid{}} = Cids.delete_cid(cid)
      assert_raise Ecto.NoResultsError, fn -> Cids.get_cid!(cid.id) end
    end

    test "change_cid/1 returns a cid changeset" do
      cid = cid_fixture()
      assert %Ecto.Changeset{} = Cids.change_cid(cid)
    end
  end
end
