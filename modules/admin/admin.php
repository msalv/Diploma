<?php

// Define current module root directory
define( 'ADMIN_ROOT', dirname(__FILE__) );

require_once ADMIN_ROOT . '/AdminController.php';

$c = new DocController( 'admin/admin.xsl' );

if ( !empty( $_POST ) ) {

    $c->addUser();
    exit();
}
    
$c->loadView(null, 'Person');

?>
