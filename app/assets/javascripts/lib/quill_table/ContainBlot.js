let Container = Quill.import('blots/container');
let Block = Quill.import('blots/block');

class ContainBlot extends Container {
  static create(value) {
    return super.create(value);
  }

  formats(domNode) {
    if(domNode){
      return domNode.tagName;
    }
    return this.domNode.tagName;
  }
}

ContainBlot.blotName = 'contain';
ContainBlot.tagName = 'contain';
ContainBlot.scope = Parchment.Scope.BLOCK_BLOT;
ContainBlot.defaultChild = 'block';
ContainBlot.allowedChildren = [Block, BlockEmbed, Container];

Quill.register(ContainBlot);
