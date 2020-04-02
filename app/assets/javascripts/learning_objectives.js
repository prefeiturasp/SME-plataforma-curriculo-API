$(document).ready(function(){
  if ($('form.learning_objective').length){
    $('#learning_objective_curricular_component_id').change(function(){
      fillAxesFromLearningObjectives();
    });

    function fillAxesFromLearningObjectives(){
      var parent = $('#learning_objective_axes_input ol');
      var curricular_component_id = $('#learning_objective_curricular_component_id').val();

      if (!curricular_component_id) {
        fillTextOnChecKBoxes(parent, 'Selecione um componente curricular');
        return
      }

      url = '/admin/learning_objectives/change_axes?curricular_component_id=' + curricular_component_id;
      ids = 'axis_ids'
      $.get(url, {}, function(res) {
        if (res.length === 0){
          fillTextOnChecKBoxes(parent, 'Nenhum eixo foi encontrado para o componente selecionado.');
        } else {
          create_check_box_list('learning_objective', ids, res, parent);
        }
      })
    }
  }
});
