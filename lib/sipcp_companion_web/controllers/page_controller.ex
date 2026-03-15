defmodule SipcpCompanionWeb.PageController do
  use SipcpCompanionWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
