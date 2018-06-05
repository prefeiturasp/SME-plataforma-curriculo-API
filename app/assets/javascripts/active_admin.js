//= require active_admin/base
//= require activeadmin/quill_editor/quill
//= require activeadmin/quill_editor_input
//= require divider_blot
//= require activities

function quillGetHTML(inputDelta) {
  var tempCont = document.createElement("div");
  (new Quill(tempCont)).setContents(inputDelta);

  return tempCont.getElementsByClassName("ql-editor")[0].innerHTML;
}

window.onload = function() {
  var editors = document.querySelectorAll( '.quill-editor' );
  for( var i = 0; i < editors.length; i++ ) {
    initializeQuillEditor(editors[i]);
  }
  defineDividerIcon();
  convertContentToDelta(editors);
};

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

function defineDividerIcon(){
  divider = $('.ql-divider')[0]
  divider.innerHTML = "_"
}

function addHrDividerOnEditor(quill) {
  const range = quill.getSelection();
  quill.insertText(range.index, '\n', Quill.sources.USER);
  quill.insertEmbed(range.index + 1, 'divider', true, Quill.sources.USER);
  quill.setSelection(range.index + 2, Quill.sources.SILENT);
}

function convertContentToDelta(editors){
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
