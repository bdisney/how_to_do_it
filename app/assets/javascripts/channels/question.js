App.question = App.cable.subscriptions.create('QuestionChannel', {
    connected: function () {
        this.followCurrentQuestion();
        this.installPageChangeCallback();
    },
    received: function (data) {
        if (typeof data.answer !== 'undefined') {
            var answer = $.parseJSON(data.answer);
            $('.answers-list').append(JST["templates/answer"](answer));
        }
        if (typeof data.comment !== 'undefined') {
            var comment = $.parseJSON(data.comment),
                $parent = $('[data-' + comment.parent.type + '-id ="' + comment.parent.id + '"]');
            $parent.find('.comments-list').append(JST["templates/comment"](comment));
        }
    },
    followCurrentQuestion: function() {
        var question_id = $('.question').data('question-id');
        if (typeof question_id !== 'undefined')
            this.perform('follow', { question_id: question_id });
        else
            this.perform('unfollow');
    },
    installPageChangeCallback: function () {
        if (!this.installedPageChangeCallback) {
            this.installedPageChangeCallback = true;
            $(document).on('turbolinks:load', function() {
                App.question.followCurrentQuestion();
            });
        }
    }
});