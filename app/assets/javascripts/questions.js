$(function() {
	$('#question').on('click', '#edit-question-link', function(e){
  	e.preventDefault();
  	$(this).hide();
  	$('form.edit_question').show();
  });

  $("#question-vote").bind('ajax:success', function(e,data,status,xhr){
  	var response = $.parseJSON(xhr.responseText);
    $("#question-vote").html(response.output);
    $("<div>"+response.message+"</div>").prependTo('body').fadeOut('slow');
  }).bind('ajax:error', function(e,data,status,xhr){
  	var response = $.parseJSON(xhr.responseText);
  	$("<div>"+response.message+"</div>").prependTo('body').fadeOut('slow');
  });

});