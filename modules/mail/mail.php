<?php

// Define current module root directory
define( 'MESSAGES_ROOT', dirname(__FILE__) );

require_once MESSAGES_ROOT . '/MessageController.php';

if ( isset($counter) ) {
    $c = new MessageController(null);
    echo $c->getCounter();
    exit();
}
else if ( isset($to) ){
    
    $c = new MessageController( 'mail/send.xsl' );

    if ( !empty($_POST) ) {
        $c->sendMessage($to);
        exit();
    }
    else {
        $form = $c->showSendForm($to);
        $c->loadView($form);
    }
}
else if ( isset($msg) ) {

    $c = new MessageController( 'mail/message.xsl' );

    $msg = $c->getMessage($msg);

    $c->loadView($msg);
}
else if ( isset($outbox) ) {

    $c = new MessageController( 'mail/outbox.xsl' );

    if ( isset( $page ) ) {
        $mail = $c->getOutbox($page);
    }
    else {
        $mail = $c->getOutbox();
    }

    $c->loadView($mail, null, true);
}
else {

    $c = new MessageController( 'mail/inbox.xsl' );

    if ( isset( $page ) ) {
        $mail = $c->getInbox($page);
    }
    else {
        $mail = $c->getInbox();
    }

    $c->loadView($mail, null, true);
}


?>
