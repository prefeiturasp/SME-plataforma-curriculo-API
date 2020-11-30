$(document).ready(function(){
  $('#public_consultation_cover_image').change(function(){
    $('#cover_image_file').hide();
  });
  $('#public_consultation_documents').change(function(){
    $('.public_consultation_file').hide();
  });
  $('#public_consultation_initial_date').change(function(){
    $('#public_consultation_initial_date')[0].value = `${$('#public_consultation_initial_date')[0].value} 00:00:00`
  });
  $('#public_consultation_final_date').change(function(){
    $('#public_consultation_final_date')[0].value = `${$('#public_consultation_final_date')[0].value} 23:59:59`
  });
});
