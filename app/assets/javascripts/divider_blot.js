let BlockEmbed = Quill.import('blots/block/embed');

class DividerBlot extends BlockEmbed {
  static create(value) {
    let node = super.create(value);
    node.setAttribute('style', "height:0px; margin-top:10px; margin-bottom:10px;");
    return node;
  }
}
DividerBlot.blotName = 'divider';
DividerBlot.className = 'hr';
DividerBlot.tagName = 'hr';

Quill.register(DividerBlot);