defmodule WabanexWeb.SchemaTest do
  use WabanexWeb.ConnCase, async: true

  alias Wabanex.User
  alias Wabanex.Users.Create

  describe "users queries" do
    test "when a valid id is given, returns the user", %{conn: conn} do
      params = %{email: "lucas@banana.com", name: "Lucas", password: "123456"}

      {:ok, %User{id: user_id}} = Create.call(params)

      query = """
        {
          user(id: "#{user_id}") {
            name
            email
          }
        }
      """

      expected_response = %{
        "data" => %{
          "user" => %{
            "email" => "lucas@banana.com",
            "name" => "Lucas"
          }
        }
      }

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert response == expected_response
    end
  end

  describe "users mutations" do
    test "when all params are valid, creates the user", %{conn: conn} do
      mutation = """
        mutation {
          createUser(input: {
            email: "lucas10@banana.com",
            name: "Lucas10",
            password: "123456"
          }) {
            id
            name
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{"createUser" => %{"id" => _id, "name" => "Lucas10"}}
             } = response
    end
  end
end
