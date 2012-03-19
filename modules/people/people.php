<?php

    // Define current module root directory
    define( 'MODULE_ROOT', dirname(__FILE__) );
    
    require MODULE_ROOT . '/models/Person.php';
    require MODULE_ROOT . '/mappers/PersonMapper.php';
    require MODULE_ROOT . '/controllers/PersonController.php';
    require PROJECT_ROOT . '/core/XSLViewLoader.php';
    
    if ( isset($username) ) {
        
        $c = new PersonController( new XSLViewLoader('person.xsl') );
        
        $c->showUserInfo($username);
        
    }
    else {
        $c = new PersonController( new XSLViewLoader('people.xsl') );
        
        $c->showUserList();
    }

?>