ActiveAdmin.register ActivityType do
  permit_params :name

  config.filters = false
end
