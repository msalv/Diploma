// owners modals
(function($){
    
    var openSubs = function(e) {
       
        var url = $(this).attr('href') + '?mode=modal',
            $dialog = $('div#common-modal');
             
       if ($dialog.html() != "") {
           $dialog.modal();
           e.preventDefault();
           return;
       }
       
       $.get(url).done(function(data){
           
           $dialog.html(data);
           
           $('a.thumbnail', $dialog).on('click', function(e) {
               var $this = $(this),
                   $a = $this.clone(),
                   $fields = $('form#add-form fieldset');
                   i = $a.attr('data-id');
                   
               $this.hide();
               $fields.append('<input type="hidden" name="owners['+ i +']" value="'+ i +'" />');
               $('ul', $fields).append( $('<li class="span1"></li>').append( $a ) );
               
               $a.on('click', function(e){
                   var j = $(this).attr('data-id');
                   
                   $(this).parent().remove();
                   $('input[value="'+ j +'"]', $fields).remove();
                   
                   $this.show();
                   e.preventDefault();
               });
               
               e.preventDefault();
           });
           
           $dialog.modal();
       })
       .fail(function(){
            console.log('getting failed');
        });
       
       e.preventDefault();
    };
    
    $('a#add-owner').on('click', openSubs);
    
})(jQuery);

// owners removing
(function($){
    
    var $fields = $('form#remove-form fieldset'),
        $ul = $('ul#markable');
        
    $('a.thumbnail', $ul).on('click', function(e){
        var $this = $(this),
            $img = $('img', $this),
            original = $img.attr('src'),
            cross = '/media/img/cross.png',
            i = $this.attr('data-id');
        
        if (original != cross) {
            $img.attr('src', cross);
            $img.attr('data-original', original);
            
            $fields.append('<input type="hidden" name="removed['+ i +']" value="'+ i +'" />');
        }
        else {
            $img.attr('src', $img.attr('data-original') );
            
            $('input[value="'+ i +'"]', $fields).remove();
        }
        
        e.preventDefault();
    });
    
})(jQuery);
