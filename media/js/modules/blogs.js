// blog modals
(function($){
    
    var openModal = function(e) {
       
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
    
    $('a#show-subs').on('click', openModal);
    $('a#attach').on('click', openModal);
    
})(jQuery);

// handling menu items hovers
(function($){
    
    $('ul.dropdown-menu li').hover(function(){
        $('i', this).toggleClass('icon-white');
    });

})(jQuery);

// posting
(function($){
    
    function postHandler(formId, containerId) {
        var $content = $('textarea#content'),
            $title = $('input#title');

        $content.on('focus', function() {
            $content.attr('rows', '3');
        });

        $content.on('blur', function() {
            if ($content.val() == "") {
                $content.attr('rows', '1');
            }
        });

        var $form = $(formId);
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
                        $(containerId).html(data).hide().fadeIn(500, function() {
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
    }
    
    postHandler('form#blog-posting', '#posts');
    postHandler('form#comm-posting', '#comments');
    
})(jQuery);