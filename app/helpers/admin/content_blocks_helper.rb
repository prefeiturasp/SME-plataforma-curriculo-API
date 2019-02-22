module Admin
  module ContentBlocksHelper
    def link_to_add_fields(name, form, association, content_type)
      new_object = form.object.class.reflect_on_association(association).klass.new
      fields = fields_html(form, association, new_object, content_type)
      onclick = h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields.to_s)}\", \"\"); return false;")

      link_to name.to_s, '#',
              onclick: onclick,
              data: { id: 'id' },
              class: "button #{content_type}"
    end

    def fields_html(form, association, new_object, content_type)
      content_block = ContentBlock.find_by(content_type: content_type)
      fields = form.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
        render(partials_path + content_type.to_s.singularize + '_fields', f: builder, content_block: content_block)
      end

      "<fieldset class='inputs has_many_fields new_content #{content_type}'><ol>#{fields}</ol></fieldset>"
    end

    def partials_path
      ContentBlock.partials_path
    end
  end
end
