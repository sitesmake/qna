$(function() {
  $('.edit-answer-link').click(function(e){
  	e.preventDefault();
  	$(this).hide();
  	var answer_id = $(this).data('answer-id');
  	$('form#edit_answer_' + answer_id).show();
  });
});
