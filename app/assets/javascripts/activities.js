$(document).ready(function(){
  var body = document.getElementsByClassName('show admin_activities');
  if (body[0]) {
    var row_content = body[0].getElementsByClassName('row-content');
    var td = row_content[0].getElementsByTagName("td")[0]
    var content = td.innerHTML;
    
    var obj = JSON.parse(content);
    var html_content = quillGetHTML(obj)
    td.innerHTML = html_content
  }

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
