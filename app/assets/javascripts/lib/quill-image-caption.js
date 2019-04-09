var Parchment = Quill.import('parchment');
const CaptionElement = new Parchment.Attributor.Attribute('caption', 'data-caption');

var FigureOptions = function(quill, options){
  this.quill = quill;
  this.quill.root.addEventListener('click', function(evt){
    if (!evt.target) {
      return false;
    } else {
      if (setFigure(evt, quill)) {
        return;
      } else {
        hide();
      };
    }
  }, false);

  this.quill.root.parentNode.style.position = this.quill.root.parentNode.style.position || 'relative';
  this.quill.on('selection-change', (range, oldRange, source) => {
    this.linkRange = oldRange;
  });
};

function setFigure(evt, quill) {
  this.img = evt.target;

  
  if (evt.target.classList.contains('new-image-format')) {
    this.setBaseFigure(evt.target, quill);
    return true;
  } else {
    let node = getNode(evt.target);
    if (node) {
      this.setBaseFigure(node, quill);
      return true;
    }
  }
  return false;
}

Quill.register('modules/imageOptions', FigureOptions);

function setBaseFigure(figure, quill) {
  if (this.figure === figure) {
    return;
  }
  if (this.figure) {
    this.hide();
  }
  this.show(figure, quill);
}

function getNode(node) {
  while (node != undefined || node != null) {
    if (node.classList && node.classList.contains('new-image-format')) { break; }
    node = node.parentNode;
  }

  return node;
}

function show(figure, quill) {
  this.figure = figure;
  this.figure.classList.add('with-options');
  this.showOverlay(quill);
}

function showOverlay(quill) {
  this.quill = quill;
  if (this.overlay) {
    this.hideOverlay();
  }

  this.quill.setSelection(null);

  // prevent spurious text selection
  this.setUserSelect('none');

  // Create and add the overlay
  this.overlay = document.createElement('div');

  setOverlayStyle(this.overlay);

  const inputField = document.createElement('input');
  inputField.setAttribute("type", "text");

  if (this.figure.dataset.caption !== undefined) {
    inputField.value = this.figure.dataset.caption;
  }
  inputField.placeholder = 'Insira sua legenda aqui...';

  inputField.addEventListener('input', (event) => {
    // stop listening for image deletion or movement
    // document.removeEventListener('keyup', this.checkImage);
    // this.quill.root.removeEventListener('input', this.checkImage);

    CaptionElement.add(this.img, inputField.value);
  });

  this.overlay.appendChild(inputField);

  const cancel = createCancelButton();
  this.overlay.appendChild(cancel);

  this.quill.root.parentNode.appendChild(this.overlay);

  this.repositionElements();
}

function setUserSelect(value) {
  [
    'userSelect',
    'mozUserSelect',
    'webkitUserSelect',
    'msUserSelect',
  ].forEach((prop) => {
    // set on contenteditable element and <html>
    this.quill.root.style[prop] = value;
    document.documentElement.style[prop] = value;
  });
}

function repositionElements() {
  if (!this.overlay || !this.figure) {
    return;
  }

  // position the overlay over the image
  const parent = this.quill.root.parentNode;
  const imgRect = this.figure.getBoundingClientRect();
  const containerRect = parent.getBoundingClientRect();
  var width = imgRect.width / 2;
  
  Object.assign(this.overlay.style, {
      left: `${imgRect.left - containerRect.left - 1 + parent.scrollLeft + width}px`,
      top: `${imgRect.top - containerRect.top + parent.scrollTop - 65}px`,
      width: `${imgRect.width}px`
  });
}

function hide() {
  if (this.figure) {
    this.figure.classList.remove('with-options');
    this.figure = undefined;
  }
  this.hideOverlay();
}

function hideOverlay() {
  if (!this.overlay) {
    return;
  }

  // Remove the overlay
  this.quill.root.parentNode.removeChild(this.overlay);
  this.overlay = undefined;

  // reset user-select
  this.setUserSelect('');
}

function createCancelButton(){
  const cancel = document.createElement('a');
  cancel.classList.add('fa');
  cancel.classList.add('fa-times');
  cancel.style.marginLeft = '5%';
  cancel.style.textDecoration = 'none';
  cancel.innerText = 'Fechar ';

  cancel.addEventListener('click', (event) => {
    this.hide();
  });

  return cancel;
}

function setOverlayStyle(overlay) {
  const style = overlay.style;
  style.position = 'absolute';
  style.background = '#fff';
  style.border = '2px solid #444';
  style.borderRadius = '5px';
  style.width = 'auto';
  style.display = 'table';
  style.padding = '10px';
  style.margin = '0 auto';
  style.left = '50%';
  style.transform = 'translateX(-50%)';
  style.borderBottom = '2px solid #fff';
  this.overlay.classList.add('new-image-format-options');
}
