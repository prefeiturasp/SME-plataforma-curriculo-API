var BaseImageFormat = Quill.import('formats/image');
const ImageFormatAttributesList = [
    'alt',
    'height',
    'width',
    'style',
    'data-caption'
];

class ImageFormat extends BaseImageFormat {
  static formats(domNode) {
    return ImageFormatAttributesList.reduce(function(formats, attribute) {
      if (domNode.hasAttribute(attribute)) {
        formats[attribute] = domNode.getAttribute(attribute);
      }
      return formats;
    }, {});
  }
  format(name, value) {
    if (ImageFormatAttributesList.indexOf(name) > -1) {
      if (value) {
        this.domNode.setAttribute(name, value);
      } else {
        this.domNode.removeAttribute(name);
      }
    } else {
      super.format(name, value);
    }
  }
}

Quill.register(ImageFormat, true);

var Image = Quill.import('formats/image');
Image.className = 'new-image-format';
Quill.register(Image, true);
