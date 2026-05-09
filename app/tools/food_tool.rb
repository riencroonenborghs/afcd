# frozen_string_literal: true

class FoodTool < ApplicationTool
  description "Query the AFCD Food Database"

  # Optional: Add annotations to provide hints about the tool's behavior
  # annotations(
  #   title: 'User Greeting',
  #   read_only_hint: true,      # This tool only reads data
  #   open_world_hint: false     # This tool only accesses the local database
  # )
  annotations(
    title: "Query the AFCD Food Database",
    read_only_hint: true,
    open_world_hint: false
  )

  arguments do
    required(:query).filled(:string).description("Food name or partial name")
    optional(:verbose).maybe(:bool).description("Verbose output")
    optional(:limit).maybe(:integer).description("Max. rows to return (default 10, max 50)")
  end

  def call(query:, verbose: false, limit: 10)
    limit = [limit.to_i.clamp(1, 50), 50].min

    scope = Food
    scope = scope.where("LOWER(food_name) LIKE LOWER(?)", "%#{query}%")
    scope = scope.limit(limit)

    results = scope.map { |food| food.as_json(verbose: verbose) }

    { count: results.size, results: results }
  end
end
