# frozen_string_literal: true

# Usage:
#   bundle exec rake afcd:export_csv
#   bundle exec rake afcd:export_csv XLSX_PATH=/custom/path/to/file.xlsx
#   bundle exec rake afcd:export_csv OUTPUT_PATH=/tmp/nutrients.csv

require "csv"

namespace :afcd do
  desc "Export 'All solids & liquids per 100 g' sheet from the AFCD xlsx to a downloadable CSV"
  task export_csv: :environment do
    require "roo"

    xlsx_path   = ENV.fetch("XLSX_PATH", Rails.root.join("lib/data/AFCD_Release_3_-_Nutrient_profiles.xlsx").to_s)
    output_path = ENV.fetch("OUTPUT_PATH", Rails.root.join("public/afcd_nutrients.csv").to_s)
    sheet_name  = "All solids & liquids per 100 g"
    header_row  = 3   # 1-indexed: rows 1-2 are title/blank, row 3 holds column headers

    raise "XLSX not found at #{xlsx_path}" unless File.exist?(xlsx_path)

    puts "Opening #{xlsx_path} …"
    xlsx = Roo::Spreadsheet.open(xlsx_path)
    sheet = xlsx.sheet(sheet_name)

    last_row    = xlsx.last_row
    last_column = xlsx.last_column

    puts "Sheet has #{last_row - header_row} data rows × #{last_column} columns"
    puts "Writing CSV to #{output_path} …"

    CSV.open(output_path, "w", force_quotes: true) do |csv|
      (header_row..last_row).each do |row_num|
        row = sheet.row(row_num)
        row = row.map { |x| x.is_a?(String) ? x.gsub(/\n/,"") : x } # clean up
        # Skip rows that are entirely nil (e.g. any blank rows after the header block)
        next if row.all?(&:nil?)

        csv << row
      end
    end

    puts "Done. #{File.size(output_path)} bytes written to #{output_path}"
  end
end
