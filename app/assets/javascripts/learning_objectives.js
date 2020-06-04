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
  $('#learning_objective_segment_id').change(function(){
    var segment_id = $(this).val();
    $.ajax({
      type: "GET",
      url: "/api/v1/stages",
      dataType: "json",
      data: {'segment_id': segment_id},
      success: function(result){
        $('#learning_objective_stage_id option').remove();
        for (var i = 0; i < result.length; i++){
          $('#learning_objective_stage_id').append(
            new Option(`${result[i]['name']}`, `${result[i]['id']}`)
          );
        }
        var stage_id = $('#learning_objective_stage_id').val();
        $.ajax({
          type: "GET",
          url: "/api/v1/years",
          dataType: "json",
          data: {'segment_id': segment_id, 'stage_id': stage_id},
          success: function(result){
            $('#learning_objective_year_id option').remove();
            for (var i = 0; i < result.length; i++){
              $('#learning_objective_year_id').append(
                new Option(`${result[i]['name']}`, `${result[i]['id']}`)
              );
            }
          }
        });
      }
    });
  });
  $('#learning_objective_stage_id').change(function(){
    var segment_id = $('#learning_objective_segment_id').val();
    var stage_id = $(this).val();
    $.ajax({
      type: "GET",
      url: "/api/v1/years",
      dataType: "json",
      data: {'segment_id': segment_id, 'stage_id': stage_id},
      success: function(result){
        $('#learning_objective_year_id option').remove();
        for (var i = 0; i < result.length; i++){
          $('#learning_objective_year_id').append(
            new Option(`${result[i]['name']}`, `${result[i]['id']}`)
          );
        }
      }
    });
  });
});
