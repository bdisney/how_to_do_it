
$(document).on('turbolinks:load', function() {
    $(document).on('ajax:beforeSend', 'form.new_comment', function() {
        $(this).find('.alert-danger').remove();
    }).on('ajax:success', 'form.new_comment', function() {
        var $form_container = $(this).closest('.comment-form');
        $form_container.find('.row').remove();
        $form_container.find('.add-comment').show();
    }).on('ajax:error', 'form.new_comment', function(e, xhr) {
        $(this).prepend(JST["templates/errors"](xhr.responseJSON));
    });
    $(document).on('ajax:success', '.comment-delete', function() {
        $(this).closest('.comment').fadeOut().remove();
    });
});