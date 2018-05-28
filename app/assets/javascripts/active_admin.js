//= require active_admin/base
//= require activeadmin/quill_editor/quill
//= require activeadmin/quill_editor_input
//= require activities

function quillGetHTML(inputDelta) {
  var tempCont = document.createElement("div");
  (new Quill(tempCont)).setContents(inputDelta);

  return tempCont.getElementsByClassName("ql-editor")[0].innerHTML;
}

window.onload = function() {
  var editors = document.querySelectorAll( '.quill-editor' );
  var default_options = {
    modules: {
      toolbar: [
        ['bold', 'italic', 'underline'],
        ['link', 'blockquote', 'code-block'],
        [{ 'script': 'sub'}, { 'script': 'super' }],
        [{ 'align': [] }, { list: 'ordered' }, { list: 'bullet' }],
        [{ 'color': [] }, { 'background': [] }],
        ['clean']
      ]
    },
    placeholder: '',
    theme: 'snow'
  };

  for( var i = 0; i < editors.length; i++ ) {
    var content = editors[i].querySelector( '.quill-editor-content' );
    if( content ) {
      // antigo
      var input = editors[i].querySelector( 'input[type="hidden"]' );
      var quill_editor_content = editors[i].getElementsByClassName('quill-editor-content');

      if (input.value) {
        var obj = JSON.parse(input.value);
        var html_content = quillGetHTML(obj)
        input.value = html_content
        quill_editor_content[0].innerHTML = html_content
        
      }

      var options = editors[i].getAttribute( 'data-options' ) ? JSON.parse( editors[i].getAttribute( 'data-options' ) ) : default_options;
      editors[i]['_quill-editor'] = new Quill( content, options );

      // Override image toolbar
      editor = editors[i]['_quill-editor']
      editor.getModule('toolbar').addHandler('image', function() {
        selectLocalImage(editor);
      });
      
    }
  }

  var formtastic = document.querySelector( 'form.formtastic' );
  if( formtastic ) {
    formtastic.onsubmit = function() {
      for( var i = 0; i < editors.length; i++ ) {
        var input = editors[i].querySelector( 'input[type="hidden"]' );

        delta = editors[i]['_quill-editor'].getContents();
        input.value = JSON.stringify(delta);
      }
    };
  }
};

// Quill Editor - Select local image
function selectLocalImage(editor) {
  const input = document.createElement('input');
  input.setAttribute('type', 'file');
  input.click();

  // Listen upload local image and save to server
  input.onchange = () => {
    const file = input.files[0];
    // file type is only image.
    if (/^image\//.test(file.type)) {
      saveToServer(file, editor);
    } else {
      console.warn('You could only upload images.');
    }
  };
}

// Quill Editor - save image to server
function saveToServer(file, editor) {
  var id = document.getElementById('activity_id').value;
  const fd = new FormData();
  fd.append('activity[content_images]', file);
  fd.append('image', file);

  const xhr = new XMLHttpRequest();
  xhr.open('POST', 'http://localhost:3000/api/v1/activities/'+id+'/file_uploads', true);
  xhr.onload = () => {
    console.log(xhr.status);
    if (xhr.status === 201) {
      // this is callback data: url
      const url = JSON.parse(xhr.responseText);
      insertToEditor(url, editor);
    }
  };
  xhr.send(fd);
}

 // Quill Editor - insert image url to rich editor.
function insertToEditor(url, editor) {
  // push image url to rich editor.
  const range = editor.getSelection();
  editor.insertEmbed(range.index, 'image', url);
}
