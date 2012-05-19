// blog modals
(function($){
    
    var openSubs = function(e) {
       
        var url = $(this).attr('href') + '?mode=modal';
             
       $.get(url).done(function(data){
           $dialog = $('div#common-modal');
           $dialog.html(data);
           
           $dialog.modal();
       })
       .fail(function(){
            console.log('getting failed');
        });
       
       e.preventDefault();
    };
    
    $('a#show-subs').on('click', openSubs);
    
})(jQuery);

// handling menu items hovers
(function($){
    
    $('ul.dropdown-menu li').hover(function(){
        $('i', this).toggleClass('icon-white');
    });

})(jQuery);

// posting
(function($){
    var $content = $('textarea#content'),
        $title = $('input#title');

    $content.on('focus', function() {
        $content.attr('rows', '5');
    });

    $content.on('blur', function() {
        if ($content.val() == "") {
            $content.attr('rows', '1');
        }
    });

    var $form = $('form#blog-posting');
    $form.on('submit', function(e){

        if ($title.val() == "") {
            $title.focus();
        }
        else if ($content.val() == "") {
            $content.focus();
        }
        else {
            $.post( $form.attr('action'), $form.serialize() )
                .done(function(data){
                    $('#posts').html(data).hide().fadeIn(500, function() {
                        $title.val('');
                        $content.val('').attr('rows', '1');
                    });
                });
        }

        e.preventDefault();
    });
    
    $content.keydown( function(e) {
        if (e.ctrlKey && e.keyCode == 13) {
            $form.submit();
        }
    });
    
})(jQuery);