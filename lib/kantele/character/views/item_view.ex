defmodule NonceGeekDAO.Character.ItemView do
  use Kalevala.Character.View

  alias Kalevala.Character.Conn.EventText
  alias NonceGeekDAO.World.Items

  def render("name", %{item_instance: item_instance} = attributes) do
    context = Map.get(attributes, :context, :none)

    item = item_instance.item

    [
      ~i({item-instance id="#{item_instance.id}" context="#{context}" name="#{item.name}" description="#{
        item.description
      }"}),
      render("name", %{item: item}),
      ~i({/item-instance})
    ]
  end

  def render("name", %{item: item}) do
    ~i({item id="#{item.id}"}#{item.name}{/item})
  end

  def render("getcontract", %{item_id: "global:airdropper"}) do
    %EventText{
      topic: "Character.Info",
      data: "airdropper",
      text: ~i"""
      {table}
        {row}
          {cell}Contract Info{/cell}
        {/row}
        {row}
          {cell}0x7d12e10ef578e047e73a45b2949dffe3475997f2e5efc0beb10a2e51df16dce7{/cell}
        {/row}
      {/table}
      """
    }
  end

  def render("getcontract", %{item_id: "global:crowdfund"}) do
    %EventText{
      topic: "Character.Info",
      data: "Crowdfund",
      text: ~i"""
        {table}
          {row}
            {cell}Contract Info{/cell}
          {/row}
          {row}
            {cell}TODO{/cell}
          {/row}
        {/table}
      """
    }
  end

  def render("getcontract", %{item_id: "global:genreadme"}) do
    %EventText{
      topic: "Character.Info",
      data: "GenerateReadme",
      text: ~i"""
        {table}
          {row}
            {cell}Tool Info{/cell}
          {/row}
          {row}
            {cell}https://dao-system.gigalixirapp.com/readme_generator{/cell}
          {/row}
        {/table}
      """
    }
  end

  def render("drop-abort", %{reason: :missing_verb, item: item}) do
    ~i(You cannot drop #{render("name", %{item: item})})
  end

  def render("drop-commit", %{item_instance: item_instance}) do
    %EventText{
      topic: "Inventory.DropItem",
      data: %{item_instance: item_instance},
      text: ~i(You dropped #{render("name", %{item_instance: item_instance, context: :room})}.\n)
    }
  end

  def render("pickup-abort", %{reason: :missing_verb, item: item}) do
    ~i(You cannot pick up #{render("name", %{item: item})}\n)
  end

  def render("pickup-commit", %{item_instance: item_instance}) do
    %EventText{
      topic: "Inventory.PickupItem",
      data: %{item_instance: item_instance},
      text:
        ~i(You picked up #{render("name", %{item_instance: item_instance, context: :inventory})}.\n)
    }
  end

  def render("unknown", %{item_name: item_name}) do
    ~i(There is no item {color foreground="white"}"#{item_name}"{/color}.\n)
  end
end
