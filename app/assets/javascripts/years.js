$(document).ready(function(){
  $('#year_segment_id').change(function(){
    var segment_id = $(this).val();
    $.ajax({
      type: "GET",
      url: "/api/v1/stages",
      dataType: "json",
      data: {'segment_id': segment_id},
      success: function(result){
        $('#year_stage_id option').remove();
        for (var i = 0; i < result.length; i++){
          $('#year_stage_id').append(
            new Option(`${result[i]['name']}`, `${result[i]['id']}`)
          );
        }
      }
    });
  });
});
