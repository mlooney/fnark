defmodule Fnark.SessionController do
  use Fnark.Web, :controller

  alias Fnark.Auth

  def create(conn, %{"email" => email, "password"=>password}) do
      case Auth.verify_email(email, password) do
        {:ok, user} ->
          conn
          |>sign_in(user)
          |>render("login.json")
        {:error, _}->
          conn
          |>put_status(:unprocessable_entity)
      end
  end
  def create(conn, %{"username" => username, "password"=>password}) do
      case Auth.verify_username(username, password) do
        {:ok, user} ->
          conn
          |>sign_in(user)
          |>render("login.json")
        {:error, _}->
          conn
          |>put_status(:unprocessable_entity)
      end
  end

  defp sign_in(conn, user) do
    conn
    |>Guardian.Plug.api_sign_in(user)
    |> add_jwt
  end


  defp add_jwt(conn) do
    jwt = Guardian.Plug.current_token(conn)
    assign(conn, :jwt, jwt)
  end


end
