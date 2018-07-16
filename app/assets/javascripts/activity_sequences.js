$(document).ready(function(){
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
  });

  $('#activity_sequence_year').change(function(){
    fill_axes();
  });
});


function fill_axes(){
  main_curricular_component_id = $('#activity_sequence_main_curricular_component_id').val();
  year = $('#activity_sequence_year').val();

  url = '/admin/activity_sequences/change_axes'

  params = {
    main_curricular_component_id: main_curricular_component_id,
    year: year
  }

  parent = $('#activity_sequence_axes_input ol');
  if (main_curricular_component_id && year) {
    $.get(url, params, function getAxes(res){
      if (res.length === 0){
        fillTextOnChecKBoxes(parent, 'Nenhum eixo foi encontrado para o ano e componente selecionados.');
      }
      res.forEach(function(axis){
        create_check_box_list(parent, axis[0], axis[1]);
      });
    });
  } else if (year) {
    fillTextOnChecKBoxes(parent, 'Selecione um componente curricular');
  } else{
    fillTextOnChecKBoxes(parent, 'Selecione um ano e um componente curricular');
  }

}

function create_check_box_list(parent, name, id){
  clean_check_boxes(parent);
  var show_id = 'activity_sequence_knowledge_matrix_ids_'+id;
  var li = $('<li/>')
      .addClass('choice')
      .appendTo(parent);

  var label = $('<label/>')
      .addClass('choice')
      .attr('for', show_id)
      .attr('title', name)
      .appendTo(li)

  var input = $('<input/>')
      .attr('type', 'checkbox')
      .attr('name', 'activity_sequence[knowledge_matrix_ids][]')
      .attr('id', show_id)
      .attr('value', id)
      .attr('multiple', 'multiple')
      .appendTo(label);

  label.append(name);

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
// <li class="choice"> 
//   <label for="activity_sequence_knowledge_matrix_ids_1">
//     <input type="checkbox" name="activity_sequence[knowledge_matrix_ids][]" 
// id="activity_sequence_knowledge_matrix_ids_1" value="1" multiple="multiple">1 - Pensamento Científico, Crítico e Criativo
//   </label>
//   </li>