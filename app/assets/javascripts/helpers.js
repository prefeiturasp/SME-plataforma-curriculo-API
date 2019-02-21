function create_check_box_list(object, method, collection, parent){
  clean_check_boxes(parent);
  collection.forEach(function(data){
    var id = data[0];
    var name = data[1];
    var tooltip = data[2] || name;

    var show_id = object+'_'+ method +'_'+id;
    var input_name = object+'['+method+'][]'
    var li = $('<li/>')
        .addClass('choice')
        .appendTo(parent);

    var label = $('<label/>')
        .addClass('choice')
        .attr('for', show_id)
        .attr('title', tooltip)
        .appendTo(li)

    var input = $('<input/>')
        .attr('type', 'checkbox')
        .attr('name', input_name)
        .attr('id', show_id)
        .attr('value', id)
        .attr('multiple', 'multiple')
        .appendTo(label);

    label.append(name);
  });
}

function fillTextOnChecKBoxes(parent, fill_text){
  clean_check_boxes(parent);
  var li = $('<li/>')
    .addClass('none_available')
    .appendTo(parent);

  var label = $('<label/>')
    .addClass('none_available')
    .appendTo(li)
    .text(fill_text)
}

function clean_check_boxes(parent){
  parent.empty();
}