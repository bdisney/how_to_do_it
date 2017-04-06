$(document).on('turbolinks:load', function() {
    $('.vote a').on('ajax:success', function(e, data) {
        var $vote_container = $(this).closest('.vote'),
            $vote_links = $vote_container.find('a'),
            $rating = $vote_container.find('.rating');
        
        $vote_links.removeClass('voted');
        $rating.text(data.rating);
        if (typeof data.vote !== 'undefined') {
            $vote_links.filter(data.vote > 0 ? '.vote-up' : '.vote-down').addClass('voted');
        }
    }).on('ajax:error', function(e, xhr) {
        console.log(xhr.responseJSON);
    });
});