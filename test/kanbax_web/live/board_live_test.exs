defmodule KanbaxWeb.BoardLiveTest do
  use KanbaxWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Kanbax.Kanban

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "some updated description", title: "some updated title"}
  @invalid_attrs %{description: nil, title: nil}

  defp fixture(:board) do
    {:ok, board} = Kanban.create_board(@create_attrs)
    board
  end

  defp create_board(_) do
    board = fixture(:board)
    %{board: board}
  end

  describe "Index" do
    setup [:create_board]

    test "lists all boards", %{conn: conn, board: board} do
      {:ok, _index_live, html} = live(conn, Routes.board_index_path(conn, :index))

      assert html =~ "Listing Boards"
      assert html =~ board.description
    end

    test "saves new board", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.board_index_path(conn, :index))

      assert index_live |> element("a", "New Board") |> render_click() =~
               "New Board"

      assert_patch(index_live, Routes.board_index_path(conn, :new))

      assert index_live
             |> form("#board-form", board: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#board-form", board: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.board_index_path(conn, :index))

      assert html =~ "Board created successfully"
      assert html =~ "some description"
    end

    test "updates board in listing", %{conn: conn, board: board} do
      {:ok, index_live, _html} = live(conn, Routes.board_index_path(conn, :index))

      assert index_live |> element("#board-#{board.id} a", "Edit") |> render_click() =~
               "Edit Board"

      assert_patch(index_live, Routes.board_index_path(conn, :edit, board))

      assert index_live
             |> form("#board-form", board: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#board-form", board: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.board_index_path(conn, :index))

      assert html =~ "Board updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes board in listing", %{conn: conn, board: board} do
      {:ok, index_live, _html} = live(conn, Routes.board_index_path(conn, :index))

      assert index_live |> element("#board-#{board.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#board-#{board.id}")
    end
  end

  describe "Show" do
    setup [:create_board]

    test "displays board", %{conn: conn, board: board} do
      {:ok, _show_live, html} = live(conn, Routes.board_show_path(conn, :show, board))

      assert html =~ "Show Board"
      assert html =~ board.description
    end

    test "updates board within modal", %{conn: conn, board: board} do
      {:ok, show_live, _html} = live(conn, Routes.board_show_path(conn, :show, board))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Board"

      assert_patch(show_live, Routes.board_show_path(conn, :edit, board))

      assert show_live
             |> form("#board-form", board: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#board-form", board: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.board_show_path(conn, :show, board))

      assert html =~ "Board updated successfully"
      assert html =~ "some updated description"
    end
  end
end
