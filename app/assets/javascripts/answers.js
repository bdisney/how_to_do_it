$(document).on('turbolinks:load', function() {
    $(document).on('ajax:beforeSend', 'form.new_answer', function() {
        $(this).find('.alert-danger').remove();
    }).on('ajax:success', 'form.new_answer', function() {
        $(this).find('input, textarea').val('');
        $(this).find('.nested-fields').not(':last').remove();
    }).on('ajax:error', 'form.new_answer', function(e, xhr) {
        $(this).prepend(JST["templates/errors"](xhr.responseJSON));
    });
});