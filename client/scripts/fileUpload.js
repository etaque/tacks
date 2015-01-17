"use strict";

var $ = require('jquery');

function fileUpload(el, name) {
  var $div = $(el),
    $input = $div.find("input:file");

  $input.change(function(e) {
    if (this.files[0]) {
      var data = new FormData();
      data.append(name, this.files[0]);
      $.ajax({
        url: $(this).data().action,
        data: data,
        cache: false,
        contentType: false,
        processData: false,
        type: 'POST',
        success: function(data) {
          $div.find('img').attr("src", data.url);
          $div.find('.alert').fadeIn();
          $input.replaceWith($input.val('').clone(true));
        }
      });
    }
  });
}

module.exports = fileUpload;
