$(document).ready(function(){
  var body = document.getElementsByClassName('show admin_activities');
  if (body[0]) {
    var row_content = body[0].getElementsByClassName('row-content');
    var td = row_content[0].getElementsByTagName("td")[0]
    var content = td.innerHTML;
    
    var obj = JSON.parse(content);
    var html_content = quillGetHTML(obj)
    td.innerHTML = html_content
  }

  form = $('form.activity')
  if(form.length) {
    $("input[name='activity[image]']").change(function() {
      validateSize(this);
    });

    action_buttons = $('fieldset.actions')
    form.append(action_buttons);

    $('.gallery-image-add-button').change( function(){
      parent = $(this).parent();
      hint = parent.find("p.inline-hints")
      hint.empty();
    });

    setToolbarToActivityContents();
    setTitleLegendClassNames();
    bindUpdateStructureOnRemove();
    setContentStructure();
    hideUnusedRemoveButton();
    stickyContentsSidebar();
  }

});

function setActivityContentBlockToolbarId(){
  $fieldsets = $('fieldset.has_many_fields')
  for( var i = 0; i < $fieldsets.length; i++ ) {
    var new_id = new Date().valueOf() + i;
    $toolbar = $($fieldsets[i]).find(".replace-id")
    if($toolbar.length) {
      $toolbar.attr("id",`toolbar_${new_id}`);

      quill = $($fieldsets[i]).find('.quill-editor');
      data_options = quill.data("options");
      data_options.modules.toolbar = `#toolbar_${new_id}`;

      $($fieldsets[i]).find('.quill-editor')

      $(quill).attr('data-options', JSON.stringify(data_options));
    }
  }
  return true;
}

function hideUnusedRemoveButton(){
  $('li.activity_content_blocks .has_many_fields .has_many_remove').hide();
  $('li.has_many_containes.images .has_many_remove').show();
}

function setTitleLegendClassNames(){
  titles = $('legend.title_content_block')
  for( var i = 0; i < titles.length; i++ ) {
    class_name = titles[i].className;
    class_name = class_name.replace('_title_content_block', '').replace('title_content_block', '');
    parent = $(titles[i]).parent().parent();
    parent.addClass(class_name);
  }
}

function bindUpdateStructureOnRemove(){
  $('a.remove-activity-content-block').click( function(e){
    e.preventDefault();
    fieldset = $(this).parent().parent().parent();
    ol = $(this).parent().parent();

    if(fieldset.length){
      input_id = ol.find('.activity-content-id');
      if(input_id.val()) {
        fieldset.addClass('hidden');
        destroy_input = ol.find('.destroy-input');
        destroy_input.val("1");
        span_title_content_block = ol.find('.title_content_block span')
        span_title_content_block.addClass('removed');
      } else {
        fieldset.remove();

      }
      setContentStructure();
    }

    goToTop($('.panel_contents').offset().top)
  });
}

function setContentStructure(){
  contents = $('li .has_many_fields');
  structure_list = $('.activity-content-structure ol');
  $('.activity-content-structure ol li').remove();
  for( var i = 0; i < contents.length; i++ ) {
    span = $(contents[i]).find('ol legend span')
    var content_name = span.text();
    if(content_name) {
      if(!span.hasClass('removed')){
        new_li =  $("<li></li>").text(content_name);
        structure_list.append(new_li);
      }
    }
  }
}

function validateSize(file) {
  var FileSize = file.files[0].size / 1024 / 1024;
  if (FileSize > 2) {
      alert('A imagem deve ser menor que 2MB. Selecione outra imagem.');
     $(file).val('');
  }
}

function add_fields(link, association, content, father) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");

  content = content.replace(regexp, new_id)
  regexp = new RegExp("NEW_RECORD_ID[0-9]+", "g");
  content = content.replace(regexp, new_id)
  regexp = new RegExp("NEW_RECORD_ID", "g");
  content = content.replace(regexp, new_id)
  $('li.activity_content_blocks').append(content)

  // INITIALIZE QUILL EDITOR 
  editor = $(`#activity_activity_content_blocks_attributes_${new_id}_body.quill-editor`)
  if (editor.length) {
    initializeQuillEditor(editor[0])
    quill_content = editor[0].querySelector(".quill-editor-content");
    toolbar = $(`#toolbar_${new_id}`)
    if (toolbar.length) {
      editor[0].insertBefore(toolbar[0], quill_content)
    }
  }

  convertAllEditorsToDelta();
  setContentStructure();
  bindUpdateStructureOnRemove();
  last_fieldset = $('li.activity_content_blocks fieldset').last()

  goToTop(last_fieldset.offset().top)

  return false;
};

function setToolbarToActivityContents(){
  var editors = document.querySelectorAll( '.quill-editor' );
  for( var i = 0; i < editors.length; i++ ) {
    content = editors[i].querySelector(".quill-editor-content");
    div_parent = content.parentElement;
    toolbar_options = JSON.parse(div_parent.dataset.options);
    toolbar_id = toolbar_options.modules.toolbar;
    toolbar = $(toolbar_id);
    editors[i].insertBefore(toolbar[0], content);
  }
}

function goToTop(offset) {
  setTimeout(function() {
    $("html, body").animate({ scrollTop: offset }, 1000);
  }, 400);
}

function stickyContentsSidebar(){
  $('.activity-content-structure').sticky({topSpacing:0});
  $('.activity-content-buttons').sticky({topSpacing:0});
}