$(function() {
	$('#question').on('click', '#edit-question-link', function(e){
  	e.preventDefault();
  	$(this).hide();
  	$('form.edit_question').show();
  });

  $("#question .vote").bind('ajax:success', function(e,data,status,xhr){
  	var response = $.parseJSON(xhr.responseText);
    $("#question .vote").html(response.output);
    $("<div>"+response.message+"</div>").prependTo('body').fadeOut('slow');
  }).bind('ajax:error', function(e,data,status,xhr){
  	var response = $.parseJSON(xhr.responseText);
  	$("<div>"+response.message+"</div>").prependTo('body').fadeOut('slow');
  });

  var current_user = $('body').data('currentUser');

  PrivatePub.subscribe('/questions', function(data, channel){
    var question = $.parseJSON(data['question']);
    if (question.user_id != current_user) {
      $('body').append('<p><a href="/questions/'+question.id+'">'+question.title+'</a></p>');
    };
  });

  var question_id = $('#question').data('questionId');

  PrivatePub.subscribe('/questions/'+question_id+'/comments/questions', function(data, channel){
    var comment = $.parseJSON(data['comment']);
    if (comment.user_id != current_user) {
      $('#question-'+question_id+'-comments').append('<li>'+comment.body+'</li>');
    };
  });

});