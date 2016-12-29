defmodule Fnark.SessionControllerTest do
  use Fnark.ConnCase
  alias Fnark.User

  @valid_attrs %{email: 'm@loonsoft.com', password: 'password', username: "username", realname: "realname"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    changeset = User.changeset(%User{}, %{email: "m@example.com", password: 'test', realname: 'realname', username: 'mml'})
    u = Repo.insert!(changeset)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
      on_exit fn ->
        IO.puts "finishing"
        Repo.delete_all(User, u.id)
      end
  end



  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @valid_attrs
    assert json_response(conn, 201)["jwt"]
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

end
