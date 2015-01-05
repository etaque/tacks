var $ = require('jquery');
var React = require('react');
var LiveCenter = React.createFactory(require('./liveCenter.jsx'));


$(function() {

  $("#liveCenter").each(function() {
    React.render(LiveCenter(), this);
  });

  $(".upload-avatar").each(function() {
    var $div = $(this),
      $input = $div.find("input:file");

    $input.change(function(e) {
      if (this.files[0]) {
        var data = new FormData();
        data.append('avatar', this.files[0]);
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

  });
  //
  //$(".upload-avatar input:file").change(function(e) {
  //  if (this.files[0]) {
  //    var data = new FormData();
  //    data.append('avatar', this.files[0]);
  //    $.ajax({
  //      url: $(this).data().action,
  //      data: data,
  //      cache: false,
  //      contentType: false,
  //      processData: false,
  //      type: 'POST',
  //      success: function(data) {
  //        $('.upload-avatar img').attr("src", data.url);
  //        $('.upload-avatar .alert').slideDown();
  //        $('.upload-avatar input').val('');
  //      }
  //    });
  //  }
  //});

});
