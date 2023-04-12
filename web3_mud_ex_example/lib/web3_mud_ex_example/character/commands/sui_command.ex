defmodule Web3MudExExample.Character.SuiCommand do
  @doc """
    Commands about interactor with Sui.
  """

  use Kalevala.Character.Command

  alias Kalevala.Verb
  alias Web3MudExExample.Character.SuiView
  alias Web3MudExExample.Character.ItemView
  alias Web3MudExExample.World.Items
  alias Web3MoveEx.Sui

  def get_obj(conn, %{"obj_id" => obj_id}) do
    render(conn, SuiView, "getobj", %{obj_id: obj_id})
  end

  def get_objs_by_owner(conn, %{"addr" => addr}) do
    render(conn, SuiView, "getobjsbyowner", %{addr: addr})
  end

  def drop(conn, %{"item_name" => item_name}) do
    item_instance =
      Enum.find(conn.character.inventory, fn item_instance ->
        item = Items.get!(item_instance.item_id)
        item_instance.id == item_name || item.callback_module.matches?(item, item_name)
      end)

    case !is_nil(item_instance) do
      true ->
        item = Items.get!(item_instance.item_id)

        case Verb.has_matching_verb?(item.verbs, :drop, %Verb.Context{location: "inventory/self"}) do
          true ->
            conn
            |> request_item_drop(item_instance)
            |> assign(:prompt, false)

          false ->
            conn
            |> assign(:item, item)
            |> assign(:reason, :missing_verb)
            |> render(ItemView, "drop-abort")
        end

      false ->
        render(conn, ItemView, "unknown", %{item_name: item_name})
    end
  end

  def get(conn, %{"item_name" => item_name}) do
    conn
    |> request_item_pickup(item_name)
    |> assign(:prompt, false)
  end
end
