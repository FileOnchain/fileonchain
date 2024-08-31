defmodule Fileonchain.FilesTest do
  use Fileonchain.DataCase

  alias Fileonchain.Files

  describe "files" do
    alias Fileonchain.Files.File

    import Fileonchain.FilesFixtures

    @invalid_attrs %{data: nil, filename: nil}

    test "list_files/0 returns all files" do
      file = file_fixture()
      assert Files.list_files() == [file]
    end

    test "get_file!/1 returns the file with given id" do
      file = file_fixture()
      assert Files.get_file!(file.id) == file
    end

    test "create_file/1 with valid data creates a file" do
      valid_attrs = %{data: "some data", filename: "some filename"}

      assert {:ok, %File{} = file} = Files.create_file(valid_attrs)
      assert file.data == "some data"
      assert file.filename == "some filename"
    end

    test "create_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Files.create_file(@invalid_attrs)
    end

    test "update_file/2 with valid data updates the file" do
      file = file_fixture()
      update_attrs = %{data: "some updated data", filename: "some updated filename"}

      assert {:ok, %File{} = file} = Files.update_file(file, update_attrs)
      assert file.data == "some updated data"
      assert file.filename == "some updated filename"
    end

    test "update_file/2 with invalid data returns error changeset" do
      file = file_fixture()
      assert {:error, %Ecto.Changeset{}} = Files.update_file(file, @invalid_attrs)
      assert file == Files.get_file!(file.id)
    end

    test "delete_file/1 deletes the file" do
      file = file_fixture()
      assert {:ok, %File{}} = Files.delete_file(file)
      assert_raise Ecto.NoResultsError, fn -> Files.get_file!(file.id) end
    end

    test "change_file/1 returns a file changeset" do
      file = file_fixture()
      assert %Ecto.Changeset{} = Files.change_file(file)
    end
  end
end
