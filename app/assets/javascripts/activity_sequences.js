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

  $('#activity_sequence_main_curricular_component_id').change(function(e) {
    fill_axes();
    fillLearningObjectives();
  });

  $('#activity_sequence_year').change(function(){
    fill_axes();
    fillLearningObjectives();
  });

  $('.formtastic').on('submit', function(){
    var fd = new FormData(this);
    var size = 0;
    for(var pair of fd.entries()) {
      if (pair[1] instanceof Blob)
        size += pair[1].size;
      else
        size += pair[1].length;
    }
    if ((size/1024/1024) >= 5) {
      alert("A soma do tamanho das imagens cadastradas supera o limite de 5mb. \nPor favor substitua as imagens por outras de menor tamanho")
      return false;
    }
  })
});

function fill_axes(){
  main_curricular_component_id = $('#activity_sequence_main_curricular_component_id').val();
  url = '/admin/activity_sequences/change_axes'

  params = {
    main_curricular_component_id: main_curricular_component_id
  }

  parent = $('#activity_sequence_axes_input ol');
  if (main_curricular_component_id) {
    $.get(url, params, function getAxes(res){
      if (res.length === 0){
        parent = $('#activity_sequence_axes_input ol');
        fillTextOnChecKBoxes(parent, 'Nenhum eixo foi encontrado para o componente selecionados.');
      } else {
        parent = $('#activity_sequence_axes_input ol');
        create_check_box_list('activity_sequence', 'axis_ids', res, parent);
      }
    });
  } else{
    parent = $('#activity_sequence_axes_input ol');
    fillTextOnChecKBoxes(parent, 'Selecione um ano e um componente curricular');
  }
}

function fillLearningObjectives(){
  main_curricular_component_id = $('#activity_sequence_main_curricular_component_id').val();
  year = $('#activity_sequence_year').val();

  url = '/admin/activity_sequences/change_learning_objectives'
  params = {
    main_curricular_component_id: main_curricular_component_id,
    year: year
  }

  parent = $('#activity_sequence_learning_objectives_input ol');
  if (main_curricular_component_id && year) {
    $.get(url, params, function getLearningObjectives(res){
      if (res.length === 0){
        parent = $('#activity_sequence_learning_objectives_input ol');
        fillTextOnChecKBoxes(parent, 'Nenhum objetivo de aprendizagem foi encontrado para o ano e componente selecionados.');
      } else{
        parent = $('#activity_sequence_learning_objectives_input ol');
        create_check_box_list('activity_sequence', 'learning_objective_ids', res, parent);
      }
    });
  } else if (year) {
    parent = $('#activity_sequence_learning_objectives_input ol');
    fillTextOnChecKBoxes(parent, 'Selecione um componente curricular');
  } else{
    parent = $('#activity_sequence_learning_objectives_input ol');
    fillTextOnChecKBoxes(parent, 'Selecione um ano e um componente curricular');
  }
}

function create_check_box_list(object, method, collection, parent){
  clean_check_boxes(parent);
  collection.forEach(function(data){
    var id = data[0];
    var name = data[1];
    var tooltip = data[2] || name;

    var show_id = object+'_'+ method +'_'+id;
    var input_name = object+'['+method+'][]'
    var li = $('<li/>')
        .addClass('choice')
        .appendTo(parent);

    var label = $('<label/>')
        .addClass('choice')
        .attr('for', show_id)
        .attr('title', tooltip)
        .appendTo(li)

    var input = $('<input/>')
        .attr('type', 'checkbox')
        .attr('name', input_name)
        .attr('id', show_id)
        .attr('value', id)
        .attr('multiple', 'multiple')
        .appendTo(label);

    label.append(name);
  });
}

function fillTextOnChecKBoxes(parent, fill_text){
  clean_check_boxes(parent);
  var li = $('<li/>')
    .addClass('none_available')
    .appendTo(parent);

  var label = $('<label/>')
    .addClass('none_available')
    .appendTo(li)
    .text(fill_text)
}

function clean_check_boxes(parent){
   parent.empty();
}

function showCheckBoxesTooltip(){
  label = $('.choices-group label');
  label.each(function(){
    self = $(this)
    new_title = self.find('input[type="checkbox"]')[0].title
    self.attr('title', new_title);
  });
}
