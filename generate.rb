require 'pry'
require 'csv'
require 'json'
require 'yaml'
require 'open-uri'
require_relative 'generate/data'
require_relative 'generate/utilities'

thailand =  {}
changwats =  {}
amphoes   =  {}
tambons   =  {}

tambons_data.each do |row|
  if thailand[row[7]].nil?
    thailand[row[7]] = {
      name: {
        th: row[8].gsub(/จ\./, '').strip,
        en: row[9]
      },
      amphoes: {}
    }
    changwats[row[7]] = {
      name: {
        th: row[8].gsub(/จ\./, '').strip,
        en: row[9]
      }
    }
  end

  if thailand[row[7]][:amphoes][row[4]].nil?
    thailand[row[7]][:amphoes][row[4]] = {
      name: {
        th: row[5].gsub(/อ\.|เขต/, '').strip,
        en: row[6]
      },
      tambons: {}
    }
    amphoes[row[4]] = {
      name: {
        th: row[5].gsub(/อ\.|เขต/, '').strip,
        en: row[6]
      },
      changwat_id: row[7]
    }
  end

  thailand[row[7]][:amphoes][row[4]][:tambons][row[1]] = {
    name: {
      th: row[2].gsub(/ต\.|แขวง/, '').strip,
      en: row[3]
    },
    coordinates: {
      lat: row[10],
      lng: row[11]
    },
    zipcode: zip_code_data[row[1].to_i]
  }
  tambons[row[1]] = {
    name: {
      th: row[2].gsub(/ต\.|แขวง/, '').strip,
      en: row[3]
    },
    coordinates: {
      lat: row[10],
      lng: row[11]
    },
    zipcode: zip_code_data[row[1].to_i],
    changwat_id: row[7],
    amphoe_id: row[4]
  }
end

thailand.each do |id, c|
  c[:amphoes].each do |id, a|
    a[:tambons] = sort_by_to_h(a[:tambons])
  end
  c[:amphoes] = sort_by_to_h(c[:amphoes])
end

thailand = sort_by_to_h(thailand)

output_to_dist(thailand, 'thailand')
output_to_dist(changwats, 'changwats')
output_to_dist(amphoes, 'amphoes')
output_to_dist(tambons, 'tambons')

