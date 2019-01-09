class Table extends ContainBlot {
    static create(value) {
        let tagName = 'table';
        let node = super.create(tagName);
        node.setAttribute('table_id', value);

        return node;
    }

    format() {
        this.getAttribute('table_id');
    }

    optimize(context) {
        super.optimize(context);
        let next = this.next;
        if (next != null && next.prev === this &&
            next.statics.blotName === this.statics.blotName &&
            next.domNode.tagName === this.domNode.tagName &&
            next.domNode.getAttribute('table_id') === this.domNode.getAttribute('table_id')) {
            next.moveChildren(this);
            next.remove();
        }
    }

    insertBefore(childBlot, refBlot) {
        if (this.statics.allowedChildren != null && !this.statics.allowedChildren.some(function (child) {
                return childBlot instanceof child;
            })) {
            let newChild = Parchment.create(this.statics.defaultChild, TableTrick.random_id());
            newChild.appendChild(childBlot);
            childBlot = newChild;
        }
        super.insertBefore(childBlot, refBlot)
    }

}

Table.blotName = 'table';
Table.tagName = 'table';
Table.scope = Parchment.Scope.BLOCK_BLOT;
Table.defaultChild = 'tr';
Table.allowedChildren = [TableRow];


Quill.register(Table);
