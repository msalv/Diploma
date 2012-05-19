/*
 * People module js
 */

// tabs
(function($){
       
    $('a[data-toggle="tab"]').on('show', function(e) {
        var url = $(e.target).attr('href'),
            target = $(e.target).attr('data-target');

        $.get(url).done(function( data ){
            $(target).html(data);
        });
    })
    
})(jQuery);

