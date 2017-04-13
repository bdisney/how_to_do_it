$(document).on('turbolinks:load', function() {
    $('[data-toggle="tooltip"]').tooltip() ;

    $(document).bind('ajax:error', function(e, xhr) {
        if (xhr.status == 403) {
            $('.main').prepend(JST["templates/flash"]($.parseJSON(xhr.responseText)));
        }
    });
});