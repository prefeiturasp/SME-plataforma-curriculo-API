//= require activities/form-content-structure
//= require activities/form-sortable-list

$(document).ready(function(){
  setShowContentBlocks();
  var form = $('form.activity, form.challenge, form.survey_form');
  if(form.length) {
    $("input[name='activity[image]']").change(function() {
      validateSize(this);
    });
    $('.gallery-image-add-button').change( function(){
      var parent = $(this).parent();
      var hint = parent.find("p.inline-hints");
      hint.empty();
    });
    $.when( setActivityContentBlockToolbarId() ).done(function() {
      fixActivityActionPosition();
      setToolbarToActivityContents();
      setAnchorIdIfFormError();
      setTitleLegendClassNames();
      bindUpdateStructureOnRemove();
      setContentStructure();
      setSortableList();
      hideUnusedRemoveButton();
      stickyContentsSidebar();
      setSequenceOnActivityContentBlocks();
      saveContentWhenClickInPreview();
      bindPredefinedExercisesSelect();
      fixSelectsContentToolbar();
    });
  }
});

function fixActivityActionPosition(){
  var form = $('form.activity, form.challenge, form.survey_form');
  var action_buttons = $('fieldset.actions');
  form.append(action_buttons);
}

function setActivityContentBlockToolbarId () {
  var $fieldsets = $('fieldset.has_many_fields');

  for( var i = 0; i < $fieldsets.length; i++ ) {
    var new_id = new Date().valueOf() + i;
    var $toolbar = $($fieldsets[i]).find(".replace-id");
    if($toolbar.length) {
      $toolbar.attr("id",`toolbar_${new_id}`);

      var quill = $($fieldsets[i]).find('.quill-editor');
      var data_options = quill.data("options");
      data_options.modules.toolbar = `#toolbar_${new_id}`;

      $($fieldsets[i]).find('.quill-editor');

      $(quill).attr('data-options', JSON.stringify(data_options));
    }
  }
  return true;
}

function hideUnusedRemoveButton(){
  $(
    'li.activity_content_blocks .has_many_fields .has_many_remove, ' +
    'li.challenge_content_blocks .has_many_fields .has_many_remove, ' +
    'li.survey_form_content_blocks .has_many_fields .has_many_remove'
  ).hide();
  $('li.has_many_containes.images .has_many_remove').show();
}

function setTitleLegendClassNames(){
  var titles = $('legend.title_content_block');
  for( var i = 0; i < titles.length; i++ ) {
    var class_name = titles[i].className;
    var class_name = class_name.replace('_title_content_block', '').replace('title_content_block', '');
    var parent = $(titles[i]).parent().parent();
    parent.addClass(class_name);
  }
}

function bindUpdateStructureOnRemove(){
  $('a.remove-activity-content-block, a.remove-challenge-content-block, a.remove-survey-form-content-block').click( function(e){
    e.preventDefault();
    var fieldset = $(this).parent().parent().parent();
    var ol = $(this).parent().parent();

    if(fieldset.length){
      var input_id = ol.find('.activity-content-id, .challenge-content-id, .survey-form-content-id');
      if(input_id.val()) {
        fieldset.addClass('hidden');
        var destroy_input = ol.find('.destroy-input');
        destroy_input.val("1");
        var span_title_content_block = ol.find('.title_content_block span');
        span_title_content_block.addClass('removed');
      } else {
        fieldset.remove();

      }
      setContentStructure();
      setSortableList();
      setSequenceInContentBlocks();
      setSequenceOnActivityContentBlocks();
    }
  });
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
  content = content.replace(regexp, new_id);
  regexp = new RegExp("NEW_RECORD_ID[0-9]+", "g");
  content = content.replace(regexp, new_id);
  regexp = new RegExp("NEW_RECORD_ID", "g");
  content = content.replace(regexp, new_id);
  $('li.activity_content_blocks, li.challenge_content_blocks, li.survey_form_content_blocks').append(content);
  initializeQuillEditorAndToolbar(new_id);
  convertAllEditorsToDeltaOnSubmit();
  bindPredefinedExercisesSelect();
  setContentStructure();
  setSortableList();
  bindUpdateStructureOnRemove();
  setSequenceInContentBlocks();
  var last_fieldset = $('li.activity_content_blocks fieldset, li.challenge_content_blocks fieldset, li.survey_form_content_blocks fieldset').last();
  goToTop(last_fieldset.offset().top);

  setSequenceOnActivityContentBlocks();

  return false;
};

function initializeQuillEditorAndToolbar (id) {
  var editor = $(`#activity_activity_content_blocks_attributes_${id}_body.quill-editor`);

  if (!editor.length) {
    editor = $(`#challenge_challenge_content_blocks_attributes_${id}_body.quill-editor`);
  }

  if (!editor.length) {
    editor = $(`#survey_form_survey_form_content_blocks_attributes_${id}_body.quill-editor`);
  }

  if (editor.length) {
    initializeQuillEditor(editor[0]);
    var quill_content = editor[0].querySelector(".quill-editor-content");
    var toolbar = $(`#toolbar_${id}`);
    if (toolbar.length) {
      editor[0].insertBefore(toolbar[0], quill_content);
      jQuery(toolbar[0]).show();
    }
  }
}

function setToolbarToActivityContents () {
  var editors = document.querySelectorAll( '.quill-editor' );
  for( var i = 0; i < editors.length; i++ ) {
    var content = editors[i].querySelector(".quill-editor-content");
    var div_parent = content.parentElement;
    var toolbar_options = JSON.parse(div_parent.dataset.options);
    var toolbar_id = toolbar_options.modules.toolbar;
    var toolbar = $(toolbar_id);

    if (typeof toolbar_id == 'string') {
      editors[i].insertBefore(toolbar[0], content);
      jQuery(toolbar[0]).show();
    }
  }
}

function bindPredefinedExercisesSelect(){
  var $selects = $('fieldset.predefined_exercise select').not('.ql-header');
  for( var i = 0; i < $selects.length; i++ ) {
    var select = $($selects[i]);
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
  $(
    '.activity-content-structure, .challenge-content-structure, .survey-form-content-structure, .activity-content-buttons, .challenge-content-buttons, .survey-form-content-buttons'
  ).sticky({topSpacing:0});
}

function setAnchorIdIfFormError(){
  var regexp = new RegExp("NEW_RECORD_ID", "g");
  var fieldsets = $('fieldset.has_many_fields');
  for(var i = 0; i < fieldsets.length; i++){
    var element = $(fieldsets[i]).find('#anchor_NEW_RECORD_ID');
    element.attr('id', `anchor_${i}`);
  }
}

function setSequenceOnActivityContentBlocks() {
  var fieldset_list = $('fieldset.has_many_fields');
  for ( var i = 0; i < fieldset_list.length; i++) {
    var sequence = i + 1;
    var sequence_input = $(fieldset_list[i]).find('.sequence-input');
    sequence_input.val(sequence);
  }
}

function setShowContentBlocks(){
  var $row_bodys = $('body.show.admin_activities, body.show.admin_challenges, body.show.admin_survey_forms')
    .find('.show-content-blocks').find('.row-body');
  for(var i = 0; i < $row_bodys.length; i++) {
    var td = $($row_bodys[i]).find('td')[0];
    var content = td.innerHTML;
    var obj = JSON.parse(content);
    var html_content = quillGetHTML(obj);
    td.innerHTML = html_content;
  }
}

function fixSelectsContentToolbar(){
  $('span.ql-formats span.ql-picker').removeClass('select2-hidden-accessible');
}
