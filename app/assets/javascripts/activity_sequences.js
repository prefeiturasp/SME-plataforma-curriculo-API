$(document).ready(function(){
  showCheckBoxesTooltip();
  var body = document.getElementsByClassName('show admin_activity_sequences');
  if (body[0]) {
    var row_content = body[0].getElementsByClassName('row-books');
    var td = row_content[0].getElementsByTagName("td")[0]
    var content = td.innerHTML;

    var obj = JSON.parse(content);
    var html_content = quillGetHTML(obj)
    td.innerHTML = html_content
  }

  fill_axes();
  $('#activity_sequence_main_curricular_component_id').change(function(e) {
    fill_axes();
    fillLearningObjectives();
  });

  $('#activity_sequence_year').change(function(){
    fill_axes();
    fillLearningObjectives();
  });
});

function fillCheckBoxes(path, parent, ids, model) {
  url = '/admin/activity_sequences/' + path
  $.get(url, {}, function(res) {
    onGetResponse(res, parent, ids, model);
  })
}

function fill_axes(){
  var parent = $('#activity_sequence_axes_input ol');
  var main_curricular_component_id = $('#activity_sequence_main_curricular_component_id').val();
  if (!main_curricular_component_id) {
    fillTextOnChecKBoxes(parent, 'Selecione um componente curricular');
    return
  }
  var path = 'change_axes?main_curricular_component_id=' + main_curricular_component_id
  fillCheckBoxes(path,
                 parent,
                 'axis_ids',
                 'eixos')
}

function fillLearningObjectives() {
  var parent = $('#activity_sequence_learning_objectives_input ol');
  var main_curricular_component_id = $('#activity_sequence_main_curricular_component_id').val();
  var year = $('#activity_sequence_year').val();

  if (!main_curricular_component_id) {
    fillTextOnChecKBoxes(parent, 'Selecione um componente curricular');
    return
  }
  if (!year) {
    fillTextOnChecKBoxes(parent, 'Selecione um ano');
    return
  }

  var path = 'change_learning_objectives?main_curricular_component_id=' + main_curricular_component_id + '&year=' + year
  fillCheckBoxes(path,
                 parent,
                 'learning_objective_ids',
                'objetivo de aprendizagem')
}

function onGetResponse(res, parent, ids, model) {
    if (res.length === 0){
      fillTextOnChecKBoxes(parent, 'Nenhum ' + model + ' foi encontrado para o componente selecionado.');
    } else {
      create_check_box_list('activity_sequence', ids, res, parent);
    }
}

function showCheckBoxesTooltip(){
  label = $('.choices-group label');
  label.each(function(){
    self = $(this)
    new_title = self.find('input[type="checkbox"]')[0].title
    self.attr('title', new_title);
  });
}
