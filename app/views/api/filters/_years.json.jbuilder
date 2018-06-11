json.years @years do |year|
  json.id Axis.years[year.first]
  json.description t("activerecord.attributes.enums.years.#{year.first}")
end
