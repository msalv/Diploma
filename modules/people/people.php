<?php

// Define current module root directory
define( 'MODULE_ROOT', dirname(__FILE__) );

require MODULE_ROOT . '/Person.php';
require MODULE_ROOT . '/PersonMapper.php';
require MODULE_ROOT . '/PersonController.php';
require PROJECT_ROOT . '/core/XSLViewLoader.php';

if ( empty($_SESSION['id']) ) {
    $c = new PersonController( new XSLViewLoader('people/auth.xsl') );
    
    if ( !empty($_POST) ) {
        $c->authenticate();
        exit();
    }

    $c->loadView();
}
else if ( isset($logout) ) {
    if ($logout == substr(session_id(), 0, 6) ) {
        setcookie(session_name(), '', time() - 3600); // it seems doesn't work
        session_unset();
        session_destroy();
    }
    header("Location: http://" . $_SERVER['HTTP_HOST']);
}
else if ( isset($username) ) {

    $c = new PersonController( new XSLViewLoader('people/person.xsl') );
    $info = $c->getUserInfo($username);
    $c->loadView($info);
}
else if ( isset($profile) ) {
    
    $c = new PersonController( new XSLViewLoader('people/profile.xsl') );
    
    if ( !empty($_POST) ) {
        $c->updateProfile();
    }
    else {
        $settings = $c->getProfileSettings();
        $c->loadView($settings);
    }
}
else if ( isset($account) ) {
    
    $c = new PersonController( new XSLViewLoader('people/account.xsl') );
    
    if ( !empty($_POST) ) {
        $c->updateAccount();
    }
    else {
        $settings = $c->getAccountSettings();
        $c->loadView($settings);
    }
}
else if ( isset($password) ) {
    $c = new PersonController( new XSLViewLoader('people/password.xsl') );
    
    if ( !empty($_POST) ) {
        $c->updatePassword();
    }
    else {
        $c->loadView(null, 'Person');
    }
}
else {    

    $c = new PersonController( new XSLViewLoader('people/people.xsl') );
    $list = $c->getUserList();
    $c->loadView($list);
}

?>