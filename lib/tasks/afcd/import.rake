# frozen_string_literal: true

# Usage:
#   bundle exec rake afcd:import
#   bundle exec rake afcd:import CSV_PATH=/path/to/import.csv
#   bundle exec rake afcd:import CSV_PATH=... MODE=upsert    # update on conflict (default)
#
# Modes:
#   upsert  (default) — insert new rows, update existing ones keyed on public_food_key
#   skip              — insert new rows only, skip rows whose public_food_key already exists

require "csv"

namespace :afcd do
  COLUMN_MAP = {
      "Public Food Key" => :public_food_key,
      "Classification" => :classification,
      "Derivation" => :derivation,
      "Food Name" => :food_name,
      "Energy with dietary fibre, equated (kJ)" => :energy_with_dietary_fibre_equated,
      "Energy, without dietary fibre, equated (kJ)" => :energy_without_dietary_fibre_equated,
      "Moisture (water) (g)" => :moisture_water,
      "Protein (g)" => :protein,
      "Nitrogen (g)" => :nitrogen,
      "Fat, total (g)" => :fat_total,
      "Ash (g)" => :ash,
      "Total dietary fibre (g)" => :total_dietary_fibre,
      "Alcohol (g)" => :alcohol,
      "Fructose (g)" => :fructose,
      "Glucose (g)" => :glucose,
      "Sucrose(g)" => :sucrose,
      "Maltose (g)" => :maltose,
      "Lactose (g)" => :lactose,
      "Galactose (g)" => :galactose,
      "Total sugars (g)" => :total_sugars,
      "Added sugars (g)" => :added_sugars,
      "Free sugars (g)" => :free_sugars,
      "Starch (g)" => :starch,
      "Dextrin (g)" => :dextrin,
      "Glycerol (g)" => :glycerol,
      "Glycogen (g)" => :glycogen,
      "Inulin (g)" => :inulin,
      "Erythritol (g)" => :erythritol,
      "Maltitol (g)" => :maltitol,
      "Mannitol (g)" => :mannitol,
      "Xylitol (g)" => :xylitol,
      "Maltodextrin (g)" => :maltodextrin,
      "Oligosaccharides  (g)" => :oligosaccharides,
      "Polydextrose (g)" => :polydextrose,
      "Raffinose (g)" => :raffinose,
      "Stachyose (g)" => :stachyose,
      "Sorbitol (g)" => :sorbitol,
      "Resistant starch (g)" => :resistant_starch,
      "Available carbohydrate, without sugar alcohols (g)" => :available_carbohydrate_without_sugar_alcohols,
      "Available carbohydrate, with sugar alcohols (g)" => :available_carbohydrate_with_sugar_alcohols,
      "Acetic acid (g)" => :acetic_acid,
      "Citric acid (g)" => :citric_acid,
      "Fumaric acid (g)" => :fumaric_acid,
      "Lactic acid (g)" => :lactic_acid,
      "Malic acid (g)" => :malic_acid,
      "Oxalic acid (g)" => :oxalic_acid,
      "Propionic acid (g)" => :propionic_acid,
      "Quinic acid (g)" => :quinic_acid,
      "Shikimic acid (g)" => :shikimic_acid,
      "Succinic acid (g)" => :succinic_acid,
      "Tartaric acid (g)" => :tartaric_acid,
      "Aluminium (Al) (ug)" => :aluminium_al,
      "Antimony (Sb) (ug)" => :antimony_sb,
      "Arsenic (As) (ug)" => :arsenic_as,
      "Cadmium (Cd) (ug)" => :cadmium_cd,
      "Calcium (Ca) (mg)" => :calcium_ca,
      "Chromium (Cr) (ug)" => :chromium_cr,
      "Chloride (Cl) (mg)" => :chloride_cl,
      "Cobalt (Co) (ug)" => :cobalt_co,
      "Copper (Cu) (mg)" => :copper_cu,
      "Fluoride (F) (ug)" => :fluoride_f,
      "Iodine (I) (ug)" => :iodine_i,
      "Iron (Fe) (mg)" => :iron_fe,
      "Lead (Pb) (ug)" => :lead_pb,
      "Magnesium (Mg) (mg)" => :magnesium_mg,
      "Manganese (Mn) (mg)" => :manganese_mn,
      "Mercury (Hg) (ug)" => :mercury_hg,
      "Molybdenum (Mo) (ug)" => :molybdenum_mo,
      "Nickel (Ni) (ug)" => :nickel_ni,
      "Phosphorus (P) (mg)" => :phosphorus_p,
      "Potassium (K) (mg)" => :potassium_k,
      "Selenium (Se) (ug)" => :selenium_se,
      "Sodium (Na) (mg)" => :sodium_na,
      "Sulphur (S) (mg)" => :sulphur_s,
      "Tin (Sn) (ug)" => :tin_sn,
      "Zinc (Zn) (mg)" => :zinc_zn,
      "Retinol (preformed vitamin A) (ug)" => :retinol_preformed_vitamin_a,
      "Alpha-carotene (ug)" => :alpha_carotene,
      "Beta-carotene (ug)" => :beta_carotene,
      "Cryptoxanthin (ug)" => :cryptoxanthin,
      "Beta-carotene equivalents (provitamin A) (ug)" => :beta_carotene_equivalents_provitamin_a,
      "Vitamin A retinol equivalents (ug)" => :vitamin_a_retinol_equivalents,
      "Lutein (ug)" => :lutein,
      "Lycopene (ug)" => :lycopene,
      "Xanthophyl (ug)" => :xanthophyl,
      "Thiamin (B1) (mg)" => :thiamin_b1,
      "Riboflavin (B2) (mg)" => :riboflavin_b2,
      "Niacin (B3) (mg)" => :niacin_b3,
      "Niacin derived from tryptophan (mg)" => :niacin_derived_from_tryptophan,
      "Niacin derived equivalents (mg)" => :niacin_derived_equivalents,
      "Pantothenic acid (B5) (mg)" => :pantothenic_acid_b5,
      "Pyridoxine (B6) (mg)" => :pyridoxine_b6,
      "Biotin (B7) (ug)" => :biotin_b7,
      "Cobalamin (B12) (ug)" => :cobalamin_b12,
      "Folate, natural (ug)" => :folate_natural,
      "Folic acid (ug)" => :folic_acid,
      "Total folates (ug)" => :total_folates,
      "Dietary folate equivalents (ug)" => :dietary_folate_equivalents,
      "Vitamin C (mg)" => :vitamin_c,
      "Cholecalciferol (D3) (ug)" => :cholecalciferol_d3,
      "Ergocalciferol (D2) (ug)" => :ergocalciferol_d2,
      "25-hydroxy cholecalciferol (25-OH D3) (ug)" => :hydroxy_cholecalciferol_25_oh_d3,
      "25-hydroxy ergocalciferol (25-OH D2) (ug)" => :hydroxy_ergocalciferol_25_oh_d2,
      "Vitamin D3 equivalents (ug)" => :vitamin_d3_equivalents,
      "Alpha tocopherol (mg)" => :alpha_tocopherol,
      "Alpha tocotrienol (mg)" => :alpha_tocotrienol,
      "Beta tocopherol (mg)" => :beta_tocopherol,
      "Beta tocotrienol (mg)" => :beta_tocotrienol,
      "Delta tocopherol (mg)" => :delta_tocopherol,
      "Delta tocotrienol (mg)" => :delta_tocotrienol,
      "Gamma tocopherol (mg)" => :gamma_tocopherol,
      "Gamma tocotrienol (mg)" => :gamma_tocotrienol,
      "Vitamin E (mg)" => :vitamin_e,
      "C4 (%T)" => :c4_t,
      "C6 (%T)" => :c6_t,
      "C8 (%T)" => :c8_t,
      "C10 (%T)" => :c10_t,
      "C11 (%T)" => :c11_t,
      "C12 (%T)" => :c12_t,
      "C13 (%T)" => :c13_t,
      "C14 (%T)" => :c14_t,
      "C15 (%T)" => :c15_t,
      "C16 (%T)" => :c16_t,
      "C17 (%T)" => :c17_t,
      "C18 (%T)" => :c18_t,
      "C19 (%T)" => :c19_t,
      "C20 (%T)" => :c20_t,
      "C21 (%T)" => :c21_t,
      "C22 (%T)" => :c22_t,
      "C23 (%T)" => :c23_t,
      "C24 (%T)" => :c24_t,
      "Total saturated fatty acids, equated (%T)" => :total_saturated_fatty_acids_equated_t,
      "C12:1 (%T)" => :c12_1_t,
      "C14:1 (%T)" => :c14_1_t,
      "C15:1 (%T)" => :c15_1_t,
      "C16:1 (%T)" => :c16_1_t,
      "C17:1 (%T)" => :c17_1_t,
      "C18:1 (%T)" => :c18_1_t,
      "C18:1w7 (%T)" => :c18_1w7_t,
      "C20:1 (%T)" => :c20_1_t,
      "C20:1w11 (%T)" => :c20_1w11_t,
      "C22:1 (%T)" => :c22_1_t,
      "C22:1w11 (%T)" => :c22_1w11_t,
      "C24:1 (%T)" => :c24_1_t,
      "Total monounsaturated fatty acids, equated (%T)" => :total_monounsaturated_fatty_acids_equated_t,
      "C12:2 (%T)" => :c12_2_t,
      "C16:2w4 (%T)" => :c16_2w4_t,
      "C16:3 (%T)" => :c16_3_t,
      "C18:2w6 (%T)" => :c18_2w6_t,
      "C18:3w3 (%T)" => :c18_3w3_t,
      "C18:3w4 (%T)" => :c18_3w4_t,
      "C18:3w6 (%T)" => :c18_3w6_t,
      "C18:4w1 (%T)" => :c18_4w1_t,
      "C18:4w3 (%T)" => :c18_4w3_t,
      "C20:2 (%T)" => :c20_2_t,
      "C20:2w6 (%T)" => :c20_2w6_t,
      "C20:4 (%T)" => :c20_4_t,
      "C20:3w3 (%T)" => :c20_3w3_t,
      "C20:3w6 (%T)" => :c20_3w6_t,
      "C20:4w3 (%T)" => :c20_4w3_t,
      "C20:4w6 (%T)" => :c20_4w6_t,
      "C20:5w3 (%T)" => :c20_5w3_t,
      "C21:5w3 (%T)" => :c21_5w3_t,
      "C22:2 (%T)" => :c22_2_t,
      "C22:2w6 (%T)" => :c22_2w6_t,
      "C22:4w6 (%T)" => :c22_4w6_t,
      "C22:5w3 (%T)" => :c22_5w3_t,
      "C22:5w6 (%T)" => :c22_5w6_t,
      "C22:6w3 (%T)" => :c22_6w3_t,
      "Total polyunsaturated fatty acids, equated (%T)" => :total_polyunsaturated_fatty_acids_equated_t,
      "Total long chain omega 3 fatty acids, equated (%T)" => :total_long_chain_omega_3_fatty_acids_equated_t,
      "Total undifferentiated fatty acids (%T)" => :total_undifferentiated_fatty_acids,
      "Total trans fatty acids, imputed (%T)" => :total_trans_fatty_acids_imputed_t,
      "C4 (g)" => :c4_g,
      "C6 (g)" => :c6_g,
      "C8 (g)" => :c8_g,
      "C10 (g)" => :c10_g,
      "C11 (g)" => :c11_g,
      "C12 (g)" => :c12_g,
      "C13 (g)" => :c13_g,
      "C14 (g)" => :c14_g,
      "C15 (g)" => :c15_g,
      "C16 (g)" => :c16_g,
      "C17 (g)" => :c17_g,
      "C18 (g)" => :c18_g,
      "C19 (g)" => :c19_g,
      "C20 (g)" => :c20_g,
      "C21 (g)" => :c21_g,
      "C22 (g)" => :c22_g,
      "C23 (g)" => :c23_g,
      "C24 (g)" => :c24_g,
      "Total saturated fatty acids, equated (g)" => :total_saturated_fatty_acids_equated_g,
      "C12:1 (g)" => :c12_1_g,
      "C14:1 (g)" => :c14_1_g,
      "C15:1 (g)" => :c15_1_g,
      "C16:1 (g)" => :c16_1_g,
      "C17:1 (g)" => :c17_1_g,
      "C18:1 (g)" => :c18_1_g,
      "C18:1w7 (g)" => :c18_1w7_g,
      "C20:1 (g)" => :c20_1_g,
      "C20:1w11 (mg)" => :c20_1w11_mg,
      "C22:1 (g)" => :c22_1_g,
      "C22:1w11 (mg)" => :c22_1w11_mg,
      "C24:1 (g)" => :c24_1_g,
      "Total monounsaturated fatty acids, equated (g)" => :total_monounsaturated_fatty_acids_equated_g,
      "C12:2 (g)" => :c12_2_g,
      "C16:2w4 (mg)" => :c16_2w4_mg,
      "C16:3 (g)" => :c16_3_g,
      "C18:2w6 (g)" => :c18_2w6_g,
      "C18:3w3 (g)" => :c18_3w3_g,
      "C18:3w4 (g)" => :c18_3w4_g,
      "C18:3w6 (mg)" => :c18_3w6_mg,
      "C18:4w1 (g)" => :c18_4w1_g,
      "C18:4w3 (mg)" => :c18_4w3_mg,
      "C20:2 (mg)" => :c20_2_mg,
      "C20:2w6 (mg)" => :c20_2w6_mg,
      "C20:3 (mg)" => :c20_3,
      "C20:3w3 (mg)" => :c20_3w3_mg,
      "C20:3w6 (mg)" => :c20_3w6_mg,
      "C20:4 (g)" => :c20_4_g,
      "C20:4w3 (mg)" => :c20_4w3_mg,
      "C20:4w6 (mg)" => :c20_4w6_mg,
      "C20:5w3 (mg)" => :c20_5w3_mg,
      "C21:5w3 (g)" => :c21_5w3_g,
      "C22:5w3 (mg)" => :c22_5w3_mg,
      "C22:4w6 (mg)" => :c22_4w6_mg,
      "C22:2 (g)" => :c22_2_g,
      "C22:2w6 (mg)" => :c22_2w6_mg,
      "C22:5w6 (g)" => :c22_5w6_g,
      "C22:6w3 (mg)" => :c22_6w3_mg,
      "Total polyunsaturated fatty acids, equated (g)" => :total_polyunsaturated_fatty_acids_equated_g,
      "Total long chain omega 3 fatty acids, equated (mg)" => :total_long_chain_omega_3_fatty_acids_equated_mg,
      "Total undifferentiated fatty acids, mass basis(mg)" => :total_undifferentiated_fatty_acids_mass_basis,
      "Total trans fatty acids, imputed (mg)" => :total_trans_fatty_acids_imputed_mg,
      "Caffeine (mg)" => :caffeine,
      "Cholesterol (mg)" => :cholesterol,
      "Alanine (mg/gN)" => :alanine_mg_gn,
      "Arginine (mg/gN)" => :arginine_mg_gn,
      "Aspartic acid (mg/gN)" => :aspartic_acid_mg_gn,
      "Cystine plus cysteine (mg/gN)" => :cystine_plus_cysteine_mg_gn,
      "Glutamic acid (mg/gN)" => :glutamic_acid_mg_gn,
      "Glycine (mg/gN)" => :glycine_mg_gn,
      "Histidine (mg/gN)" => :histidine_mg_gn,
      "Isoleucine (mg/gN)" => :isoleucine_mg_gn,
      "Leucine (mg/gN)" => :leucine_mg_gn,
      "Lysine (mg/gN)" => :lysine_mg_gn,
      "Methionine (mg/gN)" => :methionine_mg_gn,
      "Phenylalanine (mg/gN)" => :phenylalanine_mg_gn,
      "Proline (mg/gN)" => :proline_mg_gn,
      "Serine (mg/gN)" => :serine_mg_gn,
      "Threonine (mg/gN)" => :threonine_mg_gn,
      "Tyrosine (mg/gN)" => :tyrosine_mg_gn,
      "Tryptophan (mg/gN)" => :tryptophan_mg_gn,
      "Valine (mg/gN)" => :valine_mg_gn,
      "Alanine (mg)" => :alanine_mg,
      "Arginine (mg)" => :arginine_mg,
      "Aspartic acid (mg)" => :aspartic_acid_mg,
      "Cystine plus cysteine (mg)" => :cystine_plus_cysteine_mg,
      "Glutamic acid (mg)" => :glutamic_acid_mg,
      "Glycine (mg)" => :glycine_mg,
      "Histidine (mg)" => :histidine_mg,
      "Isoleucine (mg)" => :isoleucine_mg,
      "Leucine (mg)" => :leucine_mg,
      "Lysine (mg)" => :lysine_mg,
      "Methionine (mg)" => :methionine_mg,
      "Phenylalanine (mg)" => :phenylalanine_mg,
      "Proline (mg)" => :proline_mg,
      "Serine (mg)" => :serine_mg,
      "Threonine (mg)" => :threonine_mg,
      "Tyrosine (mg)" => :tyrosine_mg,
      "Tryptophan (mg)" => :tryptophan_mg,
      "Valine (mg)" => :valine_mg,
  }.freeze

  STRING_COLUMNS = %w[public_food_key classification derivation food_name].to_set.freeze

  desc "Import AFCD nutrient profiles CSV into afcd_nutrient_profiles table"
  task import: :environment do
    csv_path = ENV.fetch("CSV_PATH", Rails.root.join("lib/data/import.csv").to_s)
    mode     = ENV.fetch("MODE", "upsert").downcase

    raise "CSV not found: #{csv_path}" unless File.exist?(csv_path)
    raise "Unknown MODE '#{mode}'. Use: upsert, skip" unless %w[upsert skip].include?(mode)

    puts "Import mode : #{mode}"
    puts "Source      : #{csv_path}"
    puts

    inserted = 0
    updated  = 0
    skipped  = 0
    errors   = 0
    batch    = []
    batch_size = 200

    flush = lambda do
      next if batch.empty?

      case mode
      when "upsert"
        Food.upsert_all(
          batch,
          unique_by:        :public_food_key,
          update_only:      mode == "upsert" ? batch.first.keys - ["public_food_key"] : nil,
          record_timestamps: true
        )
        # upsert_all doesn't easily tell us insert vs update count; approximate:
        inserted += batch.size
      when "skip"
        existing = Food
          .where(public_food_key: batch.map { |r| r["public_food_key"] })
          .pluck(:public_food_key).to_set

        to_insert = batch.reject { |r| existing.include?(r["public_food_key"]) }
        skipped  += batch.size - to_insert.size
        Food.insert_all(to_insert, record_timestamps: true) if to_insert.any?
        inserted += to_insert.size
      end

      batch.clear
    end

    CSV.foreach(csv_path, headers: true, encoding: "UTF-8") do |row|
      record = {}

      COLUMN_MAP.each do |csv_col, db_col|
        raw = row[csv_col]
        record[db_col.to_s] =
          if raw.nil? || raw.strip.empty?
            nil
          elsif STRING_COLUMNS.include?(db_col.to_s)
            raw.strip
          else
            raw.strip
          end
      end

      record["created_at"] = record["updated_at"] = Time.current.iso8601

      if record["public_food_key"].blank?
        puts "  WARN: skipping row with blank public_food_key"
        errors += 1
        next
      end

      batch << record

      if batch.size >= batch_size
        flush.call
        print "."
        $stdout.flush
      end
    rescue => e
      puts "\n  ERROR on row (#{row['Public Food Key']}) : #{e.message}"
      errors += 1
    end

    flush.call
    puts

    puts
    puts "Done."
    puts "  Inserted/upserted : #{inserted}"
    puts "  Skipped           : #{skipped}"  if mode == "skip"
    puts "  Errors            : #{errors}"
    puts "  Total in DB       : #{Food.count}"
  end
end
