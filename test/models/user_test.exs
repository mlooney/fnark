defmodule Fnark.UserTest do
  use Fnark.ModelCase

  alias Fnark.User

  @valid_attrs %{password: "some content", email: "some content", realname: "some content", username: "some content"}
  @invalid_attrs %{username: '', email: '', password: ''}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
