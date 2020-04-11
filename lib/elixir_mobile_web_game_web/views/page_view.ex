defmodule ElixirMobileWebGameWeb.PageView do
  use ElixirMobileWebGameWeb, :view

  def games do
    Enum.map(
      DynamicSupervisor.which_children(ElixirMobileWebGame.GameDynamicSupervisor),
      fn child_tuple ->
        {id, child, type, modules} = child_tuple
        :sys.get_state(child).id
      end
    )
  end
end
