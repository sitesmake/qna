$(function() {
  $('#edit-question-link').click(function(e){
  	e.preventDefault();
  	$(this).hide();
  	$('form.edit_question').show();
  });
});
