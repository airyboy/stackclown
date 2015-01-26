Handlebars.registerHelper('include', function(templatename, options){
    var partial = Handlebars.partials[templatename];
    var context = $.extend({}, this, options.hash);
    return partial(context);
});

Handlebars.registerHelper('isCurrentUser', function(id, options){
    if ($('#user-info').data('user-id') == id) {
        return options.fn(this);
    }
});

Handlebars.registerHelper('isSignedIn', function(options){
    if ($('#user-info').data('user-signed')) {
        return options.fn(this);
    }
});

Handlebars.registerHelper('relativeTime', function(date){
    return moment(date).fromNow();
    });