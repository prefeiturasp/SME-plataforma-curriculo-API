//= require active_admin/base
//= require activeadmin_addons/all
//= require activeadmin/quill_editor/quill
//= require activeadmin/quill_editor_input
//= require helpers
//= require lib/image-resize.min
//= require lib/quill-divider-blot
//= require lib/quill-image-format
//= require lib/quill-image-caption
//= require lib/quill_table/TableTrick
//= require lib/quill_table/ContainBlot
//= require lib/quill_table/TableCellBlot
//= require lib/quill_table/TableRowBlot
//= require lib/quill_table/TableBlot
//= require lib/quill_table/TableModule
//= require katex.min
//= require mathquill.min
//= require mathquill4quill
//= require activities
//= require activity_sequences
//= require learning_objectives
//= require answer_book
//= require public_consultation
//= require years
//= require lib/jquery.sticky

function quillGetHTML(inputDelta) {
  var tempCont = document.createElement("div");
  (new Quill(tempCont)).setContents(inputDelta);

  return tempCont.getElementsByClassName("ql-editor")[0].innerHTML;
}

window.onload = function() {
  set_colors();
  enableConvertEditorsAfterHasManyAdd();
  $.when( setActivityContentBlockToolbarId() ).done(function () {
    var editors = document.querySelectorAll( '.quill-editor' );
    for (var i = 0; i < editors.length; i++) {
      initializeQuillEditor(editors[i]);
    }

    convertAllEditorsToDeltaOnSubmit();
    fixSelectsContentToolbar();
  });
};

function convertAllEditorsToDeltaOnSubmit () {
  var formtastic = document.querySelector( 'form.formtastic' );

  if (formtastic)
    formtastic.onsubmit = convertContentToDelta;
}

// disable default quill active admin init
var initQuillEditors = function() {}

function initializeQuillEditor (editor) {
  var content = editor.querySelector('.quill-editor-content');

  if (!content)
    return;

  var options = editor.getAttribute('data-options') ?
    JSON.parse(editor.getAttribute('data-options')) : getDefaultOptions();

  var quillEditor = editor['_quill-editor'] = new Quill(content, options);

  quillEditor.getModule('toolbar').addHandler('divider', addHrDividerOnEditor.bind(this, quillEditor));

  if (options.modules && options.modules.formula)
    quillEditor.enableMathQuillFormulaAuthoring();

  var input = editor.querySelector('input[type="hidden"]');
  if (input.value) {
    quillEditor.setContents(JSON.parse(input.value));

    input.value = editor.getElementsByClassName('ql-editor')[0].innerHTML;
  }

  setTimeout(setBulletContent, 1000);
}

function setBulletContent () {
  $('.bullet .quill-editor').each(function () {
    if (!$(this).prop('bullet-set')) {
      $(this)[0]["_quill-editor"].keyboard.addBinding(
        {key: ' '},
        {collapsed: true, format: {list: false}},
        function(range, context) {
          this.quill.formatLine(range.index, 1, 'list', 'bullet');
          this.quill.insertText(range.index, ' ');
          this.quill.setSelection(range.index + 1);
        }
      );

      $(this).prop('bullet-set', true);
    }
  });
}

function addHrDividerOnEditor(quill) {
  const range = quill.getSelection();
  quill.insertText(range.index, '\n', Quill.sources.USER);
  quill.insertEmbed(range.index + 1, 'divider', true, Quill.sources.USER);
  quill.setSelection(range.index + 2, Quill.sources.SILENT);
}

function convertContentToDelta () {
  var editors = document.querySelectorAll('.quill-editor');

  for (var i = 0; i < editors.length; i++) {
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
  return ((size / 1024 / 1024) < 100);
}

function getDefaultOptions(){
  return {
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
}

function set_colors(){
  var color_divs = document.querySelectorAll('div.pick_color');

  for( var i = 0; i < color_divs.length; i++ ) {
    var color_value = color_divs[i].innerHTML;
    color_divs[i].innerHTML = null;
    color_divs[i].style.width = "45px";
    color_divs[i].style.height = "45px";
    color_divs[i].style.borderRadius = '50%';
    color_divs[i].style.background = color_value;
  }
}

function addSecs(d, s) {
  return new Date(d.valueOf()+s*1000);
}

function enableConvertEditorsAfterHasManyAdd(){
  $('fieldset.has_many_fields.gallery').find('a.has_many_add').click( function(){
    setTimeout(function(){
      start = new Date();
      end = addSecs(start,0.3);
      do {start = new Date();} while (end-start > 0);
      convertAllEditorsToDeltaOnSubmit();
    },10);
  })
}
