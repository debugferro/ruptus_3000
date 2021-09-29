# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ruptus3000.Repo.insert!(%Ruptus3000.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Ruptus3000.Repo
alias Ruptus3000.Vehicle.VehicleType

Repo.insert!(%VehicleType{
    label: "bike",
    max_range: 2,
    priority_range_start: 0,
    priority_range_end: 2
})

Repo.insert!(%VehicleType{
    label: "motorcycle",
    max_range: 30,
    priority_range_start: 2,
    priority_range_end: 10
})

