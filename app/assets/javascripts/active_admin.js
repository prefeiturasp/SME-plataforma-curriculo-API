//= require active_admin/base
//= require activeadmin_addons/all
//= require activeadmin/quill_editor/quill
//= require activeadmin/quill_editor_input
//= require divider_blot
//= require helpers
//= require activities
//= require activity_sequences
//= require learning_objectives

function quillGetHTML(inputDelta) {
  var tempCont = document.createElement("div");
  (new Quill(tempCont)).setContents(inputDelta);

  return tempCont.getElementsByClassName("ql-editor")[0].innerHTML;
}

window.onload = function() {
  set_colors();
  var editors = document.querySelectorAll( '.quill-editor' );
  for( var i = 0; i < editors.length; i++ ) {
    initializeQuillEditor(editors[i]);
  }
  var formtastic = document.querySelector( 'form.formtastic' );
  if( formtastic ) {
    formtastic.onsubmit = function() {
      return convertContentToDelta(editors);
    };
  }
};

function convertAllEditorsToDelta() {
  var editors = document.querySelectorAll( '.quill-editor' );
  var formtastic = document.querySelector( 'form.formtastic' );
  if( formtastic ) {
    formtastic.onsubmit = function() {
      return convertContentToDelta(editors);
    };
  }
}

function initializeQuillEditor(editor){
  var content = editor.querySelector( '.quill-editor-content' );
  if( content ) {
    var input = editor.querySelector( 'input[type="hidden"]' );
    var quill_editor_content = editor.getElementsByClassName('quill-editor-content');

    if (input.value) {
      var obj = JSON.parse(input.value);
      var html_content = quillGetHTML(obj)
      input.value = html_content
      quill_editor_content[0].innerHTML = html_content
    }

    var options = editor.getAttribute( 'data-options' ) ? JSON.parse( editor.getAttribute( 'data-options' ) ) : getDefaultOptions();
    editor['_quill-editor'] = new Quill( content, options );
    quill_editor = editor['_quill-editor']
    quill_editor.getModule('toolbar').addHandler('divider', () => {
      addHrDividerOnEditor(quill_editor);
    });
  }
}

function addHrDividerOnEditor(quill) {
  const range = quill.getSelection();
  quill.insertText(range.index, '\n', Quill.sources.USER);
  quill.insertEmbed(range.index + 1, 'divider', true, Quill.sources.USER);
  quill.setSelection(range.index + 2, Quill.sources.SILENT);
}

function convertContentToDelta(editors){
  for( var i = 0; i < editors.length; i++ ) {
    var delta = editors[i]['_quill-editor'].getContents();
    if (!delta.ops || validFileSize(delta.ops)) {
      var input = editors[i].querySelector( 'input[type="hidden"]' );
      input.value = JSON.stringify(delta);
    } else {
      alert("A soma do tamanho das imagens cadastradas supera o limite de 5mb. \nPor favor substitua as imagens por outras de menor tamanho");
      return false;
    }
  }
};

function validFileSize(inserts) {
  var size = 0;
  for(var data of inserts) {
    var insert = data.insert;
    if (insert && insert.image) {
      size += insert.image.length;
    }
  }
  return ((size/1024/1024) < 5);
}

function getDefaultOptions(){
  default_options = {
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

  return default_options
}

function set_colors(){
  var color_divs = document.querySelectorAll('div.pick_color');

  for( var i = 0; i < color_divs.length; i++ ) {
    color_value = color_divs[i].innerHTML;
    color_divs[i].innerHTML = null;
    color_divs[i].style.width = "45px";
    color_divs[i].style.height = "45px";
    color_divs[i].style.borderRadius = '50%';
    color_divs[i].style.background = color_value;
  }
}
