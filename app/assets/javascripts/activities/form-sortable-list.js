function updateContentBlockSequenceOnDatabase() {
  var order = $('#sortable-list').sortable('toArray');
  if ($('#activity_id').val()) {
    var activity_id = $('#activity_id').val();
    var post_url = `/admin/activities/${activity_id}/activity_content_blocks/set_order`;
    var post_data = { activity_content_block_ids: order };
  }
  if ($('#challenge_id').val()) {
    var challenge_id = $('#challenge_id').val();
    var post_url = `/admin/challenges/${challenge_id}/challenge_content_blocks/set_order`;
    var post_data = { challenge_content_block_ids: order };
  }
  if ($('#survey_form_id').val()) {
    var survey_form_id = $('#survey_form_id').val();
    var post_url = `/admin/survey_forms/${survey_form_id}/survey_form_content_blocks/set_order`;
    var post_data = { survey_form_content_block_ids: order };
  }
  $.post(post_url, post_data, function(){}, 'json');
}


function getFieldsetListInOrder(){
  var $content_block_list = $('#sortable-list li');
  var fieldset_list = [];
  for ( var i = 0; i < $content_block_list.length; i++) {
    var anchor_id = $($content_block_list[i]).data('anchor_id');
    var $fieldset = $(`legend#${anchor_id}`).parent().parent();
    fieldset_list.push($fieldset);
  }

  return fieldset_list;
}

function moveContentBlocksAfterSortable(){
  var fieldset_list = getFieldsetListInOrder();
  for ( var i = 0; i < fieldset_list.length; i++) {
    if (fieldset_list[i + 1]){
      fieldset_list[i].after(fieldset_list[i + 1]);
    }
  }
}

function setSequenceInContentBlocks(){
  var fieldset_list = getFieldsetListInOrder();
  for ( var i = 0; i < fieldset_list.length; i++) {
    var sequence = i + 1;
    var sequence_input = fieldset_list[i].find('.sequence-input');
    sequence_input.val(sequence);
  }
}

function setSortableList(){
  $('#sortable-list').sortable({
    update: function() {
      $('form#edit_activity, form#edit_challenge, form#edit_survey_form').length > 0 ? updateContentBlockSequenceOnDatabase() : null;
      setSequenceInContentBlocks();
      moveContentBlocksAfterSortable();
    }
  });
  $('#sortable-list').disableSelection();
}
