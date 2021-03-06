defmodule MoonshineBrewery.EventTest do
  use MoonshineBrewery.ModelCase

  alias MoonshineBrewery.Event

  @valid_attrs %{date: "2010-04-17 14:00:00", description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.valid?
  end
end
