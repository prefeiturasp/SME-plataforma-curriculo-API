module Admin
  module ContentBlocksHelper
    def link_to_add_fields(name, f, association, content_type)
      new_object = f.object.class.reflect_on_association(association).klass.new
      partials_path = ContentBlock.partials_path
      content_block = ContentBlock.find_by(content_type: content_type)
      fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
        render(partials_path + content_type.to_s.singularize + "_fields", :f => builder, content_block: content_block)
      end
      fields = "<fieldset class='inputs has_many_fields new_content #{content_type}'><ol>#{fields.to_s}</ol></fieldset>"
      
      father = 'asdf asdf'
      link_to "#{ name }", '#', onclick: h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields.to_s)}\", \"#{father}\"); return false;"), data: { id: 'id' }, class: "button #{content_type}"
    end

    def human_attribute_content_blocks
      ContentBlock.content_types.map { |k,_v| [I18n.t("activerecord.attributes.enums.content_types.#{k}"), k] }
    end
  end
end
