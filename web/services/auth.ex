defmodule Fnark.Auth do
  alias Fnark.{Repo, User}
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  def verify_email(email, password) do
    account = Repo.one(User.find_by_email(email))
    cond do
      account && checkpw(password, account.crypted_password) ->
      {:ok, account}
      account ->
        {:error, :bad_password}
      true ->
        dummy_checkpw
        {:error, :not_found}
    end
  end

  def verify_username(username, password) do
    account = Repo.one(User.find_by_username(username))
    cond do
      account && checkpw(password, account.crypted_password) ->
      {:ok, account}
      account ->
        {:error, :bad_password}
      true ->
        dummy_checkpw
        {:error, :not_found}
    end
  end
end
