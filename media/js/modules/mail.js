/*
 * People module js
 */

// tabs
(function($){
       
    $('a[data-toggle="tab"]').off('show');
    $('a[data-toggle="tab"]').on('show', function(e) {
        var url = $(e.target).attr('href'),
            target = $(e.target).attr('data-target');
            
        if (target == "#msg") {
            $('ul li.active').removeClass('active');
        }
        
        $.get(url).done(function( data ){
            $(target).html(data);
        });
        
        $.get('/mail/counter').done(function(data){

            var num = parseInt(data);
            if (num) {
                $('span#msg-num').html( '+' + num );
            }
            else {
                $('span#msg-num').empty();
            }
        });
    })
    
})(jQuery);

// mail modals
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
    
    $('a#attach').on('click', openModal);
    
})(jQuery);

// submitting
(function($){
    
    var $form = $('form#reply');

    $form.on('submit', function(e){
        var url = $form.attr('action');
        
        $.post(url, $form.serialize() ).done(function(data){
            var meta = $('div#meta');
            $(meta).hide().html(data).fadeIn(500);
        })
        .fail(function(){
            console.log('request failed');
        });
        e.preventDefault();
    });
    
    $('textarea#content').keydown( function(e) {
        if (e.ctrlKey && e.keyCode == 13) {
            $form.submit();
        }
    });
    
})(jQuery);

