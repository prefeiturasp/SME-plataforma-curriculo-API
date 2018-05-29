$(document).ready(function(){
  $("input[name='activity[image]']").change(function() {
    validateSize(this);
  });

});

function validateSize(file) {
  var FileSize = file.files[0].size / 1024 / 1024;
  if (FileSize > 2) {
      alert('A imagem deve ser menor que 2MB. Selecione outra imagem.');
     $(file).val('');
  }
}