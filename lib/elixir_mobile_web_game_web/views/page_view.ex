defmodule ElixirMobileWebGameWeb.PageView do
  use ElixirMobileWebGameWeb, :view

  def games do
    Enum.map(
      DynamicSupervisor.which_children(ElixirMobileWebGame.Boundary.GameDynamicSupervisor),
      fn child_tuple ->
        {id, child, type, modules} = child_tuple

        %{
          state: inspect(ElixirMobileWebGame.Boundary.GameGenserver.get_state(child)),
          id: ElixirMobileWebGame.Boundary.GameGenserver.get_state(child).id
        }
      end
    )
  end
end
