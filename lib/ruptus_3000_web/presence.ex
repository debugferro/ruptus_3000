defmodule Ruptus3000Web.Presence do
  use Phoenix.Presence,
    otp_app: :ruptus_3000,
    pubsub_server: Ruptus3000.PubSub
end
