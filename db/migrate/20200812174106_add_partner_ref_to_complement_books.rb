class AddPartnerRefToComplementBooks < ActiveRecord::Migration[5.2]
  def change
      add_reference :complement_books, :partner, index: true
  end
end
