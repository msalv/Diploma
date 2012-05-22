<?php

// Define current module root directory
define( 'UPLOADS_ROOT', dirname(__FILE__) );

require_once UPLOADS_ROOT . '/DocController.php';

$c = new DocController( 'uploads/uploads.xsl' );

if ( !empty( $_FILES ) ) {

    $c->uploadDoc();
}
    
$docs = $c->getDocs();

$c->loadView($docs, null, true);


?>
