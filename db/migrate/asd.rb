class CreateFoods < ActiveRecord::Migration[7.1]
  def change
    create_table :afcd_nutrient_profiles do |t|
      # Identity
      t.string   :public_food_key, null: false
      t.string   :classification
      t.string   :derivation
      t.string   :food_name
      # Energy
      t.integer  :energy_with_dietary_fibre_equated, null: true
      t.integer  :energy_without_dietary_fibre_equated, null: true
      # Proximate nutrients
      t.decimal  :moisture_water, precision: 10, scale: 4, null: true
      t.decimal  :protein, precision: 10, scale: 4, null: true
      t.decimal  :nitrogen, precision: 10, scale: 4, null: true
      t.decimal  :fat_total, precision: 10, scale: 4, null: true
      t.decimal  :ash, precision: 10, scale: 4, null: true
      t.decimal  :total_dietary_fibre, precision: 10, scale: 4, null: true
      t.decimal  :alcohol, precision: 10, scale: 4, null: true
      # Sugars & carbohydrates
      t.decimal  :fructose, precision: 10, scale: 4, null: true
      t.decimal  :glucose, precision: 10, scale: 4, null: true
      t.decimal  :sucrose, precision: 10, scale: 4, null: true
      t.decimal  :maltose, precision: 10, scale: 4, null: true
      t.decimal  :lactose, precision: 10, scale: 4, null: true
      t.decimal  :galactose, precision: 10, scale: 4, null: true
      t.decimal  :total_sugars, precision: 10, scale: 4, null: true
      t.decimal  :added_sugars, precision: 10, scale: 4, null: true
      t.decimal  :free_sugars, precision: 10, scale: 4, null: true
      t.decimal  :starch, precision: 10, scale: 4, null: true
      t.decimal  :dextrin, precision: 10, scale: 4, null: true
      t.decimal  :glycerol, precision: 10, scale: 4, null: true
      t.decimal  :glycogen, precision: 10, scale: 4, null: true
      t.decimal  :inulin, precision: 10, scale: 4, null: true
      t.decimal  :erythritol, precision: 10, scale: 4, null: true
      t.decimal  :maltitol, precision: 10, scale: 4, null: true
      t.decimal  :mannitol, precision: 10, scale: 4, null: true
      t.decimal  :xylitol, precision: 10, scale: 4, null: true
      t.decimal  :maltodextrin, precision: 10, scale: 4, null: true
      t.decimal  :oligosaccharides, precision: 10, scale: 4, null: true
      t.decimal  :polydextrose, precision: 10, scale: 4, null: true
      t.decimal  :raffinose, precision: 10, scale: 4, null: true
      t.decimal  :stachyose, precision: 10, scale: 4, null: true
      t.decimal  :sorbitol, precision: 10, scale: 4, null: true
      t.decimal  :resistant_starch, precision: 10, scale: 4, null: true
      t.decimal  :available_carbohydrate_without_sugar_alcohols, precision: 10, scale: 4, null: true
      t.decimal  :available_carbohydrate_with_sugar_alcohols, precision: 10, scale: 4, null: true
      # Organic acids
      t.decimal  :acetic_acid, precision: 10, scale: 4, null: true
      t.decimal  :citric_acid, precision: 10, scale: 4, null: true
      t.decimal  :fumaric_acid, precision: 10, scale: 4, null: true
      t.decimal  :lactic_acid, precision: 10, scale: 4, null: true
      t.decimal  :malic_acid, precision: 10, scale: 4, null: true
      t.decimal  :oxalic_acid, precision: 10, scale: 4, null: true
      t.decimal  :propionic_acid, precision: 10, scale: 4, null: true
      t.decimal  :quinic_acid, precision: 10, scale: 4, null: true
      t.decimal  :shikimic_acid, precision: 10, scale: 4, null: true
      t.decimal  :succinic_acid, precision: 10, scale: 4, null: true
      t.decimal  :tartaric_acid, precision: 10, scale: 4, null: true
      # Minerals
      t.decimal  :aluminium_al, precision: 10, scale: 4, null: true
      t.decimal  :antimony_sb, precision: 10, scale: 4, null: true
      t.decimal  :arsenic_as, precision: 10, scale: 4, null: true
      t.decimal  :cadmium_cd, precision: 10, scale: 4, null: true
      t.decimal  :calcium_ca, precision: 10, scale: 4, null: true
      t.decimal  :chromium_cr, precision: 10, scale: 4, null: true
      t.decimal  :chloride_cl, precision: 10, scale: 4, null: true
      t.decimal  :cobalt_co, precision: 10, scale: 4, null: true
      t.decimal  :copper_cu, precision: 10, scale: 4, null: true
      t.decimal  :fluoride_f, precision: 10, scale: 4, null: true
      t.decimal  :iodine_i, precision: 10, scale: 4, null: true
      t.decimal  :iron_fe, precision: 10, scale: 4, null: true
      t.decimal  :lead_pb, precision: 10, scale: 4, null: true
      t.decimal  :magnesium_mg, precision: 10, scale: 4, null: true
      t.decimal  :manganese_mn, precision: 10, scale: 4, null: true
      t.decimal  :mercury_hg, precision: 10, scale: 4, null: true
      t.decimal  :molybdenum_mo, precision: 10, scale: 4, null: true
      t.decimal  :nickel_ni, precision: 10, scale: 4, null: true
      t.decimal  :phosphorus_p, precision: 10, scale: 4, null: true
      t.decimal  :potassium_k, precision: 10, scale: 4, null: true
      t.decimal  :selenium_se, precision: 10, scale: 4, null: true
      t.decimal  :sodium_na, precision: 10, scale: 4, null: true
      t.decimal  :sulphur_s, precision: 10, scale: 4, null: true
      t.decimal  :tin_sn, precision: 10, scale: 4, null: true
      t.decimal  :zinc_zn, precision: 10, scale: 4, null: true
      t.decimal  :retinol_preformed_vitamin_a, precision: 10, scale: 4, null: true
      t.decimal  :vitamin_a_retinol_equivalents, precision: 10, scale: 4, null: true
      t.decimal  :biotin_b7, precision: 10, scale: 4, null: true
      t.decimal  :cystine_plus_cysteine_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :cystine_plus_cysteine_mg, precision: 10, scale: 4, null: true
      # Vitamins & carotenoids
      t.decimal  :alpha_carotene, precision: 10, scale: 4, null: true
      t.decimal  :beta_carotene, precision: 10, scale: 4, null: true
      t.decimal  :cryptoxanthin, precision: 10, scale: 4, null: true
      t.decimal  :beta_carotene_equivalents_provitamin_a, precision: 10, scale: 4, null: true
      t.decimal  :lutein, precision: 10, scale: 4, null: true
      t.decimal  :lycopene, precision: 10, scale: 4, null: true
      t.decimal  :xanthophyl, precision: 10, scale: 4, null: true
      t.decimal  :thiamin_b1, precision: 10, scale: 4, null: true
      t.decimal  :riboflavin_b2, precision: 10, scale: 4, null: true
      t.decimal  :niacin_b3, precision: 10, scale: 4, null: true
      t.decimal  :niacin_derived_from_tryptophan, precision: 10, scale: 4, null: true
      t.decimal  :niacin_derived_equivalents, precision: 10, scale: 4, null: true
      t.decimal  :pantothenic_acid_b5, precision: 10, scale: 4, null: true
      t.decimal  :pyridoxine_b6, precision: 10, scale: 4, null: true
      t.decimal  :cobalamin_b12, precision: 10, scale: 4, null: true
      t.decimal  :folate_natural, precision: 10, scale: 4, null: true
      t.decimal  :folic_acid, precision: 10, scale: 4, null: true
      t.decimal  :total_folates, precision: 10, scale: 4, null: true
      t.decimal  :dietary_folate_equivalents, precision: 10, scale: 4, null: true
      t.decimal  :vitamin_c, precision: 10, scale: 4, null: true
      t.decimal  :cholecalciferol_d3, precision: 10, scale: 4, null: true
      t.decimal  :ergocalciferol_d2, precision: 10, scale: 4, null: true
      t.decimal  :hydroxy_cholecalciferol_25_oh_d3, precision: 10, scale: 4, null: true
      t.decimal  :hydroxy_ergocalciferol_25_oh_d2, precision: 10, scale: 4, null: true
      t.decimal  :vitamin_d3_equivalents, precision: 10, scale: 4, null: true
      t.decimal  :alpha_tocopherol, precision: 10, scale: 4, null: true
      t.decimal  :alpha_tocotrienol, precision: 10, scale: 4, null: true
      t.decimal  :beta_tocopherol, precision: 10, scale: 4, null: true
      t.decimal  :beta_tocotrienol, precision: 10, scale: 4, null: true
      t.decimal  :delta_tocopherol, precision: 10, scale: 4, null: true
      t.decimal  :delta_tocotrienol, precision: 10, scale: 4, null: true
      t.decimal  :gamma_tocopherol, precision: 10, scale: 4, null: true
      t.decimal  :gamma_tocotrienol, precision: 10, scale: 4, null: true
      t.decimal  :vitamin_e, precision: 10, scale: 4, null: true
      # Fatty acids (%T)
      t.decimal  :total_saturated_fatty_acids_equated_t, precision: 10, scale: 4, null: true
      t.decimal  :total_monounsaturated_fatty_acids_equated_t, precision: 10, scale: 4, null: true
      t.decimal  :total_polyunsaturated_fatty_acids_equated_t, precision: 10, scale: 4, null: true
      t.decimal  :total_long_chain_omega_3_fatty_acids_equated_t, precision: 10, scale: 4, null: true
      t.decimal  :total_undifferentiated_fatty_acids, precision: 10, scale: 4, null: true
      t.decimal  :total_trans_fatty_acids_imputed_t, precision: 10, scale: 4, null: true
      t.decimal  :total_undifferentiated_fatty_acids_mass_basis, precision: 10, scale: 4, null: true
      # Fatty acids (g/mg)
      t.decimal  :total_saturated_fatty_acids_equated_g, precision: 10, scale: 4, null: true
      t.decimal  :total_monounsaturated_fatty_acids_equated_g, precision: 10, scale: 4, null: true
      t.decimal  :total_polyunsaturated_fatty_acids_equated_g, precision: 10, scale: 4, null: true
      t.decimal  :total_long_chain_omega_3_fatty_acids_equated_mg, precision: 10, scale: 4, null: true
      t.decimal  :total_trans_fatty_acids_imputed_mg, precision: 10, scale: 4, null: true
      # Individual fatty acids (g)
      t.decimal  :c4_g, precision: 10, scale: 4, null: true
      t.decimal  :c6_g, precision: 10, scale: 4, null: true
      t.decimal  :c8_g, precision: 10, scale: 4, null: true
      t.decimal  :c10_g, precision: 10, scale: 4, null: true
      t.decimal  :c11_g, precision: 10, scale: 4, null: true
      t.decimal  :c12_g, precision: 10, scale: 4, null: true
      t.decimal  :c13_g, precision: 10, scale: 4, null: true
      t.decimal  :c14_g, precision: 10, scale: 4, null: true
      t.decimal  :c15_g, precision: 10, scale: 4, null: true
      t.decimal  :c16_g, precision: 10, scale: 4, null: true
      t.decimal  :c17_g, precision: 10, scale: 4, null: true
      t.decimal  :c18_g, precision: 10, scale: 4, null: true
      t.decimal  :c19_g, precision: 10, scale: 4, null: true
      t.decimal  :c20_g, precision: 10, scale: 4, null: true
      t.decimal  :c21_g, precision: 10, scale: 4, null: true
      t.decimal  :c22_g, precision: 10, scale: 4, null: true
      t.decimal  :c23_g, precision: 10, scale: 4, null: true
      t.decimal  :c24_g, precision: 10, scale: 4, null: true
      t.decimal  :c12_1_g, precision: 10, scale: 4, null: true
      t.decimal  :c14_1_g, precision: 10, scale: 4, null: true
      t.decimal  :c15_1_g, precision: 10, scale: 4, null: true
      t.decimal  :c16_1_g, precision: 10, scale: 4, null: true
      t.decimal  :c17_1_g, precision: 10, scale: 4, null: true
      t.decimal  :c18_1_g, precision: 10, scale: 4, null: true
      t.decimal  :c18_1w7_g, precision: 10, scale: 4, null: true
      t.decimal  :c20_1_g, precision: 10, scale: 4, null: true
      t.decimal  :c22_1_g, precision: 10, scale: 4, null: true
      t.decimal  :c24_1_g, precision: 10, scale: 4, null: true
      t.decimal  :c12_2_g, precision: 10, scale: 4, null: true
      t.decimal  :c16_3_g, precision: 10, scale: 4, null: true
      t.decimal  :c18_2w6_g, precision: 10, scale: 4, null: true
      t.decimal  :c18_3w3_g, precision: 10, scale: 4, null: true
      t.decimal  :c18_3w4_g, precision: 10, scale: 4, null: true
      t.decimal  :c18_4w1_g, precision: 10, scale: 4, null: true
      t.decimal  :c20_4_g, precision: 10, scale: 4, null: true
      t.decimal  :c21_5w3_g, precision: 10, scale: 4, null: true
      t.decimal  :c22_2_g, precision: 10, scale: 4, null: true
      t.decimal  :c22_5w6_g, precision: 10, scale: 4, null: true
      # Individual fatty acids (mg)
      t.decimal  :c20_1w11_mg, precision: 10, scale: 4, null: true
      t.decimal  :c22_1w11_mg, precision: 10, scale: 4, null: true
      t.decimal  :c16_2w4_mg, precision: 10, scale: 4, null: true
      t.decimal  :c18_3w6_mg, precision: 10, scale: 4, null: true
      t.decimal  :c18_4w3_mg, precision: 10, scale: 4, null: true
      t.decimal  :c20_2_mg, precision: 10, scale: 4, null: true
      t.decimal  :c20_2w6_mg, precision: 10, scale: 4, null: true
      t.decimal  :c20_3w3_mg, precision: 10, scale: 4, null: true
      t.decimal  :c20_3w6_mg, precision: 10, scale: 4, null: true
      t.decimal  :c20_4w3_mg, precision: 10, scale: 4, null: true
      t.decimal  :c20_4w6_mg, precision: 10, scale: 4, null: true
      t.decimal  :c20_5w3_mg, precision: 10, scale: 4, null: true
      t.decimal  :c22_5w3_mg, precision: 10, scale: 4, null: true
      t.decimal  :c22_4w6_mg, precision: 10, scale: 4, null: true
      t.decimal  :c22_2w6_mg, precision: 10, scale: 4, null: true
      t.decimal  :c22_6w3_mg, precision: 10, scale: 4, null: true
      # Other
      t.decimal  :c4_t, precision: 10, scale: 4, null: true
      t.decimal  :c6_t, precision: 10, scale: 4, null: true
      t.decimal  :c8_t, precision: 10, scale: 4, null: true
      t.decimal  :c10_t, precision: 10, scale: 4, null: true
      t.decimal  :c11_t, precision: 10, scale: 4, null: true
      t.decimal  :c12_t, precision: 10, scale: 4, null: true
      t.decimal  :c13_t, precision: 10, scale: 4, null: true
      t.decimal  :c14_t, precision: 10, scale: 4, null: true
      t.decimal  :c15_t, precision: 10, scale: 4, null: true
      t.decimal  :c16_t, precision: 10, scale: 4, null: true
      t.decimal  :c17_t, precision: 10, scale: 4, null: true
      t.decimal  :c18_t, precision: 10, scale: 4, null: true
      t.decimal  :c19_t, precision: 10, scale: 4, null: true
      t.decimal  :c20_t, precision: 10, scale: 4, null: true
      t.decimal  :c21_t, precision: 10, scale: 4, null: true
      t.decimal  :c22_t, precision: 10, scale: 4, null: true
      t.decimal  :c23_t, precision: 10, scale: 4, null: true
      t.decimal  :c24_t, precision: 10, scale: 4, null: true
      t.decimal  :c12_1_t, precision: 10, scale: 4, null: true
      t.decimal  :c14_1_t, precision: 10, scale: 4, null: true
      t.decimal  :c15_1_t, precision: 10, scale: 4, null: true
      t.decimal  :c16_1_t, precision: 10, scale: 4, null: true
      t.decimal  :c17_1_t, precision: 10, scale: 4, null: true
      t.decimal  :c18_1_t, precision: 10, scale: 4, null: true
      t.decimal  :c18_1w7_t, precision: 10, scale: 4, null: true
      t.decimal  :c20_1_t, precision: 10, scale: 4, null: true
      t.decimal  :c20_1w11_t, precision: 10, scale: 4, null: true
      t.decimal  :c22_1_t, precision: 10, scale: 4, null: true
      t.decimal  :c22_1w11_t, precision: 10, scale: 4, null: true
      t.decimal  :c24_1_t, precision: 10, scale: 4, null: true
      t.decimal  :c12_2_t, precision: 10, scale: 4, null: true
      t.decimal  :c16_2w4_t, precision: 10, scale: 4, null: true
      t.decimal  :c16_3_t, precision: 10, scale: 4, null: true
      t.decimal  :c18_2w6_t, precision: 10, scale: 4, null: true
      t.decimal  :c18_3w3_t, precision: 10, scale: 4, null: true
      t.decimal  :c18_3w4_t, precision: 10, scale: 4, null: true
      t.decimal  :c18_3w6_t, precision: 10, scale: 4, null: true
      t.decimal  :c18_4w1_t, precision: 10, scale: 4, null: true
      t.decimal  :c18_4w3_t, precision: 10, scale: 4, null: true
      t.decimal  :c20_2_t, precision: 10, scale: 4, null: true
      t.decimal  :c20_2w6_t, precision: 10, scale: 4, null: true
      t.decimal  :c20_4_t, precision: 10, scale: 4, null: true
      t.decimal  :c20_3w3_t, precision: 10, scale: 4, null: true
      t.decimal  :c20_3w6_t, precision: 10, scale: 4, null: true
      t.decimal  :c20_4w3_t, precision: 10, scale: 4, null: true
      t.decimal  :c20_4w6_t, precision: 10, scale: 4, null: true
      t.decimal  :c20_5w3_t, precision: 10, scale: 4, null: true
      t.decimal  :c21_5w3_t, precision: 10, scale: 4, null: true
      t.decimal  :c22_2_t, precision: 10, scale: 4, null: true
      t.decimal  :c22_2w6_t, precision: 10, scale: 4, null: true
      t.decimal  :c22_4w6_t, precision: 10, scale: 4, null: true
      t.decimal  :c22_5w3_t, precision: 10, scale: 4, null: true
      t.decimal  :c22_5w6_t, precision: 10, scale: 4, null: true
      t.decimal  :c22_6w3_t, precision: 10, scale: 4, null: true
      t.decimal  :c20_3, precision: 10, scale: 4, null: true
      t.decimal  :caffeine, precision: 10, scale: 4, null: true
      t.decimal  :cholesterol, precision: 10, scale: 4, null: true
      t.decimal  :alanine_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :arginine_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :aspartic_acid_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :glutamic_acid_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :glycine_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :histidine_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :isoleucine_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :leucine_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :lysine_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :methionine_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :phenylalanine_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :proline_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :serine_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :threonine_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :tyrosine_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :tryptophan_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :valine_mg_gn, precision: 10, scale: 4, null: true
      t.decimal  :alanine_mg, precision: 10, scale: 4, null: true
      t.decimal  :arginine_mg, precision: 10, scale: 4, null: true
      t.decimal  :aspartic_acid_mg, precision: 10, scale: 4, null: true
      t.decimal  :glutamic_acid_mg, precision: 10, scale: 4, null: true
      t.decimal  :glycine_mg, precision: 10, scale: 4, null: true
      t.decimal  :histidine_mg, precision: 10, scale: 4, null: true
      t.decimal  :isoleucine_mg, precision: 10, scale: 4, null: true
      t.decimal  :leucine_mg, precision: 10, scale: 4, null: true
      t.decimal  :lysine_mg, precision: 10, scale: 4, null: true
      t.decimal  :methionine_mg, precision: 10, scale: 4, null: true
      t.decimal  :phenylalanine_mg, precision: 10, scale: 4, null: true
      t.decimal  :proline_mg, precision: 10, scale: 4, null: true
      t.decimal  :serine_mg, precision: 10, scale: 4, null: true
      t.decimal  :threonine_mg, precision: 10, scale: 4, null: true
      t.decimal  :tyrosine_mg, precision: 10, scale: 4, null: true
      t.decimal  :tryptophan_mg, precision: 10, scale: 4, null: true
      t.decimal  :valine_mg, precision: 10, scale: 4, null: true

      t.timestamps
    end

    add_index :afcd_nutrient_profiles, :public_food_key, unique: true
    add_index :afcd_nutrient_profiles, :classification
    add_index :afcd_nutrient_profiles, :food_name
  end
end
