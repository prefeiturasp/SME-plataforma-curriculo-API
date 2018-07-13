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
});