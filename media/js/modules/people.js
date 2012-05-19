/*
 * People module js
 */

// pills
(function($){
    
    var requestForms = function(i, elem) {
        var $form = $(elem);
        
        $form.on('submit', function(e){
            var url = $(elem).attr('action');
            $.post(url, $form.serialize() ).done(function(data){
                var row = $form.parentsUntil('#requests').get(-1);
                $(row).hide().html(data).fadeIn(500);
            })
            .fail(function(){
                console.log('request failed');
            });
            e.preventDefault();
        });
    };
    
    $('a[data-toggle="pill"]').on('show', function(e) {
        var url = $(e.target).attr('href'),
            target = $(e.target).attr('data-target');

        $.get(url).done(function( data ){
            if (target == '#wall') {
                $('#posts').html(data);
            }
            else if (target == '#requests') {
                $(target).html(data);
                $('form', target).each( requestForms );
            }
            else {
                $(target).html(data);
            }
        });
    })
    
    $('div#requests form').each( requestForms );
    
})(jQuery);

// posting to the wall
(function($){
    var $content = $('textarea#content');

    $content.on('focus', function() {
        $content.attr('rows', '3');
    });

    $content.on('blur', function() {
        if ($content.val() == "") {
            $content.attr('rows', '1');
        }
    });

    var $form = $('div#wall form');
    $form.on('submit', function(e){

        if ($content.val() == "") {
            $content.focus();
        }
        else {
            $.post( $form.attr('action'), $form.serialize() )
                .done(function(data){
                    $('#posts').html(data).hide().fadeIn(500, function() {
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

// handling menu items hovers
(function($){
    
    $('ul.dropdown-menu li').hover(function(){
        $('i', this).toggleClass('icon-white');
    });

})(jQuery);

// modal dialogs
(function($){
       
    // handler
    var openModal = function(e) {
       
        var url = $(this).attr('href'),
       
        // submit handler
        onSubmit = function(e) {
            
            $form = $(e.target);
            $.post(url, $form.serialize() ).done(function(data){
                $('div#modal-messages').hide().html(data).fadeIn(500);
            })
            .fail(function(){
                console.log('posting failed');
            });

            e.preventDefault();
        };
       
       $.get(url).done(function(data){
           $dialog = $('div#common-modal');
           $dialog.html(data);
           
           $form = $('form', $dialog);
           
           $form.on('submit', onSubmit);
           
           $('textarea', $form).keydown( function(e) {
                if (e.ctrlKey && e.keyCode == 13) {
                    $form.submit();
                }
           });
           
           $('a#submit', $dialog).on('click', function(e) {
               
               $form.submit();
               e.preventDefault();
           });
           
           $dialog.modal();
       })
       .fail(function(){
            console.log('getting failed');
        });
       
       e.preventDefault();
    };
    
    $('a#add-friend').on('click', openModal);
    $('a#remove-friend').on('click', openModal);
    $('a#send-pm').on('click', openModal);

})(jQuery);