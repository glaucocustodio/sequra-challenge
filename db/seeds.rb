# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# rubocop:disable Rails/Output
puts("Importing merchants")
Importers::Merchant::Importer.new(csv_file_path: Rails.root.join("db/seeds/merchants.csv")).import

puts("Importing orders")
Importers::Order::Importer.new(csv_file_path: Rails.root.join("db/seeds/orders.csv")).import

puts("Processing disbursements")
Order.grouped_by_placed_at.each do |order|
  Disbursement::Processor.new(date: order.placed_at).process
end

puts("Processing minimum monthly fees")
Order.months_with_orders.each do |order|
  MinimumMonthlyFee::Processor.new(date: order.placed_month).process
end
# rubocop:enable Rails/Output
