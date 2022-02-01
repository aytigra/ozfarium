defmodule Ozfarium.Gallery.Queries do
  import Ecto.Query, warn: false

  alias Ozfarium.Gallery.Ozfa
  alias Ozfarium.Users.UserOzfa
  # alias Ozfarium.Users.User

  def preload_ozfas(user, ids) do
    user_ozfas_query = from uo in UserOzfa, where: uo.user_id == ^user.id

    from(o in Ozfa,
      where: o.id in ^ids,
      preload: [user_ozfas: ^user_ozfas_query]
    )
  end

  def my_ozfas(query, current_user, %{my: 1}) do
    user_ozfas(query, current_user)
  end

  def my_ozfas(query, _, _), do: query

  def user_ozfas(query, user) do
    owned_ozfas = from(uo in UserOzfa, where: uo.user_id == ^user.id, select: uo.ozfa_id)

    from(o in query, where: o.id in subquery(owned_ozfas))
  end
end