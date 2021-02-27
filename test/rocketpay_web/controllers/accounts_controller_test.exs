defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Rocketpay Test",
        password: "rocketpaytest",
        nickname: "testRocketpay",
        email: "test@rocketpay.com",
        age: 20
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic bmx3ZWxpeGlyOm5sd2VsaXhpcjEyMw==")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make a desposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
                "account" => %{"balance" => "50.00", "id" => _id},
                "message" => "Balance change successfully"
              } = response
    end

    test "when there are a negative value, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "-10.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => %{"balance" => ["is invalid"]}}

      assert response == expected_response
    end


    test "when there invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "ERRO"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid deposit value"}

      assert response == expected_response
    end
  end
end
