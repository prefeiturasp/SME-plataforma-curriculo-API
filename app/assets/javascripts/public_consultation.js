$(document).ready(function(){
  $('#public_consultation_cover_image').change(function(){
    $('#cover_image_file').hide();
  });
  $('#public_consultation_documents').change(function(){
    $('.public_consultation_file').hide();
  });
});
