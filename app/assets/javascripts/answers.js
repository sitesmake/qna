$(function() {
  $('.answers').on('click', '.edit-answer-link', function(e){
  	e.preventDefault();
  	$(this).hide();
  	var answer_id = $(this).data('answer-id');
  	$('form#edit_answer_' + answer_id).show();
  });
});
