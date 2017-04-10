App.questions_list = App.cable.subscriptions.create('QuestionsListChannel', {
    connected: function () {
        this.followQuestionsList();
        this.installPageChangeCallback();
    },
    received: function (data) {
        $('.questions-list').append(data.question);
    },
    followQuestionsList: function() {
        if ($('.questions-list').length)
            this.perform('follow');
        else
            this.perform('unfollow');
    },
    installPageChangeCallback: function () {
        if (!this.installedPageChangeCallback) {
            this.installedPageChangeCallback = true;
            $(document).on('turbolinks:load', function() {
                App.questions_list.followQuestionsList();
            });
        }
    }
});