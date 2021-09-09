defmodule Kanbax.Kanban.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kanbax.Kanban.Status

  schema "tasks" do
    field :title, :string
    field :description, :string

    belongs_to :status, Status

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [])
    |> validate_required([])
  end
end
