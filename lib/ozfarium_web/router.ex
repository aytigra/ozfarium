defmodule OzfariumWeb.Router do
  use OzfariumWeb, :router

  pipeline :auth do
    plug OzfariumWeb.AuthPlug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {OzfariumWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OzfariumWeb do
    pipe_through [:browser, :auth]

    live "/", Live.Gallery, :index

    live "/ozfas", Live.Gallery, :index
    live "/ozfas/new", Live.Gallery, :new
    live "/ozfas/:id/edit", Live.Gallery, :edit
    live "/ozfas/:id", Live.Gallery, :show

    live "/tags", Live.Tags, :index
    live "/tags/new", Live.Tags, :new
    live "/tags/:id/edit", Live.Tags, :edit
    live "/tags/:id", Live.Tags, :show

    delete "/session", SessionController, :delete
  end

  scope "/", OzfariumWeb do
    pipe_through :browser

    get "/signin", SessionController, :new

    get "/telegram/signin", Telegram.AuthController, :signin
  end

  # Other scopes may use custom stacks.
  # scope "/api", OzfariumWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: OzfariumWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
