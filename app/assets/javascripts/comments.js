$(document).on('turbolinks:load', function() {
    $(document).on('ajax:success', 'form.new_comment', function(e, data) {
        var $form_container = $(this).closest('.comment-form'),
            $list = $form_container.closest('.item-comments').find('.comments-list');
        $list.append(JST["templates/comment"](data));
        $form_container.find('.row').remove();
        $form_container.find('.add-comment').show();
    }).on('ajax:error', 'form.new_comment', function(e, xhr) {
        $(this).prepend(JST["templates/errors"](xhr.responseJSON));
    });
});