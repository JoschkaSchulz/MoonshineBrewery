defmodule MoonshineBrewery.UserController do
  use MoonshineBrewery.Web, :controller

  plug :action

  def login(conn, _params) do
    # TODO: check for login token?

    response = HTTPotion.post "http://127.0.0.1:4040/api/v1/login?email=joschka.schulz@gmx.de&password=12345678"

    if HTTPotion.Response.success?(response) do
      {:ok, body} = JSON.decode(response.body)
      IO.puts body["message"]

      # create login token for user :D
      generate_token(body["message"], body["user"]["username"], body["user"]["id"], conn)
    end
  end

  def generate_token("logged in", username, id, conn) do
    IO.puts "User has logged in,... token generation! (#{username})"
    uuid1 = UUID.uuid1()
    token = UUID.uuid3(uuid1, username, :hex)
    IO.puts token
    IO.puts "Token generation completed"

    user = %MoonshineBrewery.User{token: token, main_id: id}
    MoonshineBrewery.Repo.insert user

    render conn, response: %{user: %{id: id, username: username, token: token}}
  end

  def generate_token(nil, username, id, conn) do
    render conn, response: %{error: "No valid login"}
  end
end
