$(document).ready(function(){
  $('#answer_book_cover_image').change(function(){
    $('#cover_image_file').hide();
  });
  $('#answer_book_book_file').change(function(){
    $('#answer_book_file').hide();
  });
  $('#answer_book_segment_id').change(function(){
    var segment_id = $(this).val();
    $.ajax({
      type: "GET",
      url: "/api/v1/stages",
      dataType: "json",
      data: {'segment_id': segment_id},
      success: function(result){
        $('#answer_book_stage_id option').remove();
        for (var i = 0; i < result.length; i++){
          $('#answer_book_stage_id').append(
            new Option(`${result[i]['name']}`, `${result[i]['id']}`)
          );
        }
      }
    });
  });
});
