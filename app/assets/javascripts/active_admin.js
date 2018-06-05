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

  initializeQuillEditors(editors);
  defineDividerIcon();
  convertContentToDelta(editors);
};

function initializeQuillEditors(editors){
  for( var i = 0; i < editors.length; i++ ) {
    var content = editors[i].querySelector( '.quill-editor-content' );
    if( content ) {
      var input = editors[i].querySelector( 'input[type="hidden"]' );
      var quill_editor_content = editors[i].getElementsByClassName('quill-editor-content');

      if (input.value) {
        var obj = JSON.parse(input.value);
        var html_content = quillGetHTML(obj)
        input.value = html_content
        quill_editor_content[0].innerHTML = html_content
      }

      var options = editors[i].getAttribute( 'data-options' ) ? JSON.parse( editors[i].getAttribute( 'data-options' ) ) : getDefaultOptions();
      editors[i]['_quill-editor'] = new Quill( content, options );
      editor = editors[i]['_quill-editor']
      editor.getModule('toolbar').addHandler('divider', () => {
        addHrDividerOnEditor(editor);
      });
    }
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
