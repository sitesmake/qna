$(function() {
  $('.answers').on('click', '.edit-answer-link', function(e){
  	e.preventDefault();
  	$(this).hide();
  	var answer_id = $(this).data('answer-id');
  	$('form#edit_answer_' + answer_id).show();
  });

  $(".answers .vote").bind('ajax:success', function(e,data,status,xhr){
  	var response = $.parseJSON(xhr.responseText);
    $(".answer-" + response.id + " .vote").html(response.output);
    $("<div>"+response.message+"</div>").prependTo('body').fadeOut('slow');
  }).bind('ajax:error', function(e,data,status,xhr){
  	var response = $.parseJSON(xhr.responseText);
  	$("<div>"+response.message+"</div>").prependTo('body').fadeOut('slow');
  });
});
