namespace :graphql do
  task dump_schema: :environment do
    schema = StudyHubSchema
    SDL = GraphQL::Schema::Printer.print_schema(schema)
    File.write(Rails.root.join("app/graphql/study_hub_schema.graphql"), SDL)
    puts "🚀 GraphQL schema dumped to app/graphql/study_hub_schema.graphql"
  end
end
