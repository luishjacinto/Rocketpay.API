defmodule Rocketpay do
  alias Rocketpay.Accounts.{Deposit, Withdraw, Transaction}

  alias Rocketpay.Users.Create, as: UserCreate

  defdelegate deposit(params), to: Deposit, as: :call
  defdelegate withdraw(params), to: Withdraw, as: :call
  defdelegate transaction(params), to: Transaction, as: :call

  defdelegate create_user(params), to: UserCreate, as: :call
end
