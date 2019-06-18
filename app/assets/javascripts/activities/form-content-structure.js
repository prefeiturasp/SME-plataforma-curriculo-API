function createContentStructureItem(content_name, span, id_legend, li_item){
  if(content_name && !span.hasClass('removed')) {
    var icon = "<span class='icon-sortable'>&#9650;<br>&#9660;</span>";
    var link = $("<a></a>").text(content_name);
    link.attr('href', `#${id_legend}`);
    li_item = li_item.append(link).append(icon);
  }
  return li_item;
}

function createItem(activity_content_id, anchor_id){
  var li = $("<li></li>");
  li.attr('id', activity_content_id);
  li.attr('data-anchor_id', anchor_id);

  return li;
}

function getOptionalText($fieldset_parent){
  var optional_text = null;
  if ($fieldset_parent.hasClass('predefined_exercise')) {
    var select = $fieldset_parent.find('select');
    optional_text = select.val();
  }

  return optional_text;
}

function setContentStructure(){
  var contents = $('li .has_many_fields').not('.gallery-has-many-images');
  var structure_list = $('.activity-content-structure ol, .challenge-content-structure ol');
  var sortable_list = $('.activity-content-structure ul#sortable-list, .challenge-content-structure ul#sortable-list');
  $('.activity-content-structure ol li, .challenge-content-structure ol li').not(".preview-item").remove();
  for( var i = 0; i < contents.length; i++ ) {
    if (!blockWasRemoved(contents[i])) {
      var input = $(contents[i]).find('input.activity-content-id, input.challenge-content-id');
      var activity_content_id = input.val();
      var anchor_id = $(contents[i]).find('legend').attr('id');
      var $ol_parent = $(input[0]).parent().parent();
      var id_legend = $ol_parent.find('legend.title_content_block')[0].id;
      var optional_text = getOptionalText($ol_parent.parent());
      var span = $(contents[i]).find('ol legend span');
      var content_name = span.text();
      content_name = setOptionalText(content_name, optional_text);
      var li_item = createItem(activity_content_id, anchor_id);
      sortable_list.append(
        createContentStructureItem(content_name, span, id_legend, li_item)
      );
    }
  }
  structure_list.append(structure_list.find('.preview-item'));
}

function blockWasRemoved(content_block) {
  var span = $(content_block).find('ol .title_content_block span');

  return span.hasClass('removed');
}

function focusOrRedirect (win, form, post_url, data) {
  if (form.is('#new_activity') || form.is('#new_challenge')) {
    window.location.href = post_url + "/" + data.slug + "/edit";
  } else {
    window.location.reload(false);
  }
}

function openLinkInNewTab (form, data, link, post_url) {
  if (data && data.title && !data.slug)
    data.slug = slugify(data.title);

  link = (form.is("#new_activity") || form.is('#new_challenge')) ? (link + data.slug) : link;
  var win = window.open(link, '_blank');
  if (win) {
    focusOrRedirect(win, form, post_url, data);
  } else {
    alert('Por favor, permita pop-ups para este site');
  }
}

function setOptionalText(content_name, optional_text) {
  if(content_name) {
    content_name = optional_text ? `${content_name} (${optional_text})` : content_name;
  }

  return content_name;
}

function renderErrorsResponse(errors){
  var input_offset = null;
  $.each(errors, function (key, data) {
    var input_name = generateInputNameFromKey(key);
    var inputs = $(`[name^="${input_name}"]`).not('.gallery-image-add-button');
    for(var i = 0; i < inputs.length; i++){
      var input = $(inputs[i]);
      if (input.length > 0) {
        if (!input.val()) {
          input_offset = input_offset ? input_offset : input.offset().top;
          var p = $('<p />').addClass('inline-errors').text(data);
          var li = input.parent();
          if (!li.hasClass('error')) {
            li.addClass('error');
            li.append(p);
          }
        }
      }
    }
  });
  goToTop(input_offset);
}

function generateInputNameFromKey (key) {
  var input_name = "activity";
  var keySplited = key.split(".");
  for(var k of keySplited){
    if (k === 'activity_content_blocks') {
      input_name = input_name + '[activity_content_blocks_attributes]';
      break;
    } else if (k === 'challenge_content_blocks') {
      input_name = input_name + '[challenge_content_blocks_attributes]';
      break;
    } else {
      input_name = input_name + "[" + k + "]";
    }
  }
  return input_name;
}

function createOrUpdateActivityContentBlock ($activity_form, link_to_redirect) {
  var post_url = $activity_form.attr('action');
  var formData = window.FormData ? new FormData($activity_form[0]) : $activity_form.serialize();

  $.ajax({
    url: post_url +'.json',
    data: formData,
    cache: false,
    contentType: false,
    processData: false,
    type: 'POST'
  })
    .done(function (data) {
      openLinkInNewTab($activity_form, data, link_to_redirect, post_url);
    })
    .fail(function(xhr, status, error) {
      var errors = xhr.responseJSON.errors;
      alert("Houve um erro ao salvar.");
      renderErrorsResponse(errors);
    });
}

function saveContentWhenClickInPreview(){
  $('a.preview-link').on('click', function(evt){
    var link_to_redirect = $(this).attr('href');
    evt.preventDefault();
    var $activity_form = $('form.activity, form.challenge');
    if ($activity_form.length > 0) {
      convertContentToDelta();
      createOrUpdateActivityContentBlock($activity_form, link_to_redirect);
    }
  });
}

function slugify (str) {
  str = str.replace(/^\s+|\s+$/g, "");
  str = str.toLowerCase();

  // remove accents, swap ñ for n, etc
  var from = "åàáãäâèéëêìíïîòóöôùúüûñç·/_,:;",
      to   = "aaaaaaeeeeiiiioooouuuunc------";

  for (var i = 0, l = from.length; i < l; i++)
    str = str.replace(new RegExp(from.charAt(i), "g"), to.charAt(i));

  str = str
    .replace(/[^a-z0-9 -]/g, "") // remove invalid chars
    .replace(/\s+/g, "-") // collapse whitespace and replace by -
    .replace(/-+/g, "-") // collapse dashes
    .replace(/^-+/, "") // trim - from start of text
    .replace(/-+$/, ""); // trim - from end of text

  return str;
}
