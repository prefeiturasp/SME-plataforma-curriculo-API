$(document).ready(function(){
  var body = document.getElementsByClassName('show admin_activities');
  if (body[0]) {
    var row_content = body[0].getElementsByClassName('row-content');
    if (row_content.length > 0){
      var td = row_content[0].getElementsByTagName("td")[0]
      var content = td.innerHTML;
      var obj = JSON.parse(content);
      var html_content = quillGetHTML(obj)
      td.innerHTML = html_content
    }
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
    setAnchorIdIfFormError();
    setTitleLegendClassNames();
    bindUpdateStructureOnRemove();
    setContentStructure();
    hideUnusedRemoveButton();
    stickyContentsSidebar();
    saveContentWhenClickInPreview();
    bindPredefinedExercisesSelect();
  }

});

function saveContentWhenClickInPreview(){
  $('a.preview-link').on('click', function(evt){
    var link_to_redirect = $(this).attr('href');
    evt.preventDefault();
    var $activity_form = $('form.activity');
    if ($activity_form.length > 0){
      var editors = document.querySelectorAll( '.quill-editor' );
      convertContentToDelta(editors);
      var post_url = $activity_form.attr('action');
      $.post(post_url, $activity_form.serialize(), function(){},'json')
        .done(function(data){
          openLinkInNewTab($activity_form, data, link_to_redirect, post_url);
        })
        .fail(function(xhr, status, error) {
          var errors = xhr.responseJSON.errors;
          alert("Houve um erro ao salvar.");
          renderErrorsResponse(errors);
        });
    }
  });
}

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
      setSequenceInContentBlocks();
    }
  });
}

function setContentStructure(){
  var contents = $('li .has_many_fields').not('.gallery-has-many-images');
  var structure_list = $('.activity-content-structure ol');
  var sortable_list = $('.activity-content-structure ul#sortable-list');
  $('.activity-content-structure ol li').not(".preview-item").remove();
  for( var i = 0; i < contents.length; i++ ) {
    var input = $(contents[i]).find('input.activity-content-id');
    var activity_content_id = input.val();
    var anchor_id = $(contents[i]).find('legend').attr('id')
    var $ol_parent = $(input[0]).parent().parent();
    var id_legend = $ol_parent.find('legend.title_content_block')[0].id;
    var $fieldset_parent = $ol_parent.parent();

    var optional_text = null;
    if ($fieldset_parent.hasClass('predefined_exercise')) {
      select = $fieldset_parent.find('select');
      optional_text = select.val();
    }

    var span = $(contents[i]).find('ol legend span')
    var content_name = span.text();
    if(content_name) {
      if(!span.hasClass('removed')){
        content_name = optional_text ? `${content_name} (${optional_text})` : content_name
        var icon = "<span class='icon-sortable'>&#9650;<br>&#9660;</span>"
        var link = $("<a></a>").text(content_name);
        link.attr('href', `#${id_legend}`);
        var new_li = $("<li></li>").attr('id', activity_content_id).attr('data-anchor_id', anchor_id).append(link).append(icon);
        sortable_list.append(new_li);
      }
    }
  }
  structure_list.append(structure_list.find('.preview-item'));
  setSortableList();
}

function setSortableList(){
  var activity_id = $('#activity_id').val();
  post_url = `/admin/activities/${activity_id}/activity_content_blocks/set_order`
  $('#sortable-list').sortable({
    update: function() {
      $('form#edit_activity').length > 0 ? updateContentBlockSequenceOnDatabase() : null;
      setSequenceInContentBlocks();
      moveContentBlocksAfterSortable();
    }
  });
  $('#sortable-list').disableSelection();
}

function moveContentBlocksAfterSortable(){
  var fieldset_list = getFieldsetListInOrder();
  for ( var i = 0; i < fieldset_list.length; i++) {
    if (fieldset_list[i+1]){
      fieldset_list[i].after(fieldset_list[i+1])
    }
  }
}

function setSequenceInContentBlocks(){
  var fieldset_list = getFieldsetListInOrder();
  for ( var i = 0; i < fieldset_list.length; i++) {
    sequence = i + 1;
    var sequence_input = fieldset_list[i].find('.sequence-input')
    sequence_input.val(sequence);
  }
}

function getFieldsetListInOrder(){
  var $content_block_list = $('#sortable-list li');
  var fieldset_list = [];
  for ( var i = 0; i < $content_block_list.length; i++) {
    var anchor_id = $($content_block_list[i]).data('anchor_id')
    var $fieldset = $(`legend#${anchor_id}`).parent().parent();
    fieldset_list.push($fieldset);
  }

  return fieldset_list;
}

function updateContentBlockSequenceOnDatabase() {
  var order = $('#sortable-list').sortable('toArray');
  var post_data = { activity_content_block_ids: order }
  $.post(post_url, post_data, function(){}, 'json')
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
  bindPredefinedExercisesSelect();
  setContentStructure();
  bindUpdateStructureOnRemove();
  setSequenceInContentBlocks();
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

function bindPredefinedExercisesSelect(){
  var $selects = $('fieldset.predefined_exercise select').not('.ql-header')
  for( var i = 0; i < $selects.length; i++ ) {
    var select = $($selects[i])
    select.on('change', function(){
      setContentStructure();
    });
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

function setAnchorIdIfFormError(){
  regexp = new RegExp("NEW_RECORD_ID", "g");
  var fieldsets = $('fieldset.has_many_fields');
  for(var i=0; i < fieldsets.length; i++){
    var element = $(fieldsets[i]).find('#anchor_NEW_RECORD_ID');
    element.attr('id', `anchor_${i}`);
  }
}

function openLinkInNewTab($activity_form, data, link_to_redirect, post_url){
  link_to_redirect = ($activity_form.is("#new_activity")) ? (link_to_redirect + data.slug) : link_to_redirect
  var win = window.open(link_to_redirect, '_blank');
  if (win) {
    focusOrRedirect(win, $activity_form, post_url, data);
  } else {
    alert('Por favor, permita pop-ups para este site');
  }
}

function focusOrRedirect(win, $activity_form, post_url, data){
  if ($activity_form.is("#new_activity")) {
    window.location.href = post_url + "/" + data.slug + "/edit"
  } else {
    win.focus();
  }
}

function renderErrorsResponse(errors){
  var input_offset = null;
  $.each(errors, function (key, data) {
    var input_name = generateInputNameFromKey(key);
    var inputs = $(`[name^="${input_name}"]`).not('.gallery-image-add-button')
    for(var i =0; i < inputs.length; i++){
      input = $(inputs[i]);
      if (input.length > 0) {
        if (!input.val()) {
          input_offset = input_offset ? input_offset : input.offset().top;
          var p = $('<p />').addClass('inline-errors').text(data);
          var li = input.parent();
          if (!li.hasClass('error')) {
            li.addClass('error');
            li.append(p);
          }
        }
      }
    }
  });
  goToTop(input_offset);
}

function generateInputNameFromKey(key){
  var input_name = "activity";
  var keySplited = key.split(".");
  for(var k of keySplited){
    if (k == 'activity_content_blocks') {
      input_name = input_name + '[activity_content_blocks_attributes]';
      break;
    } else {
      input_name = input_name + "["+ k +"]";
    }
  }
  return input_name;
}
