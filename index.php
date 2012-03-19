<?php
    // Set default charset to UTF-8
    header('Content-Type: text/html; charset=utf-8');
    
    /**
     * Basic configuration
     */
    
    // Debug settings
    error_reporting(E_ALL);
    ini_set('display_errors', true);
    
    // Project root path
    define( 'PROJECT_ROOT', dirname(__FILE__) );
    
    // Local settings. See local_settings.sample.php for details.
    require_once PROJECT_ROOT . '/local_settings.php';
    require_once PROJECT_ROOT . '/urls.php';

    /**
     * Application entry point
     */
    
    // split uri string by question mark
    $uri = explode("?", $_SERVER['REQUEST_URI'], 2);
    $matches = array();
    
    // URI matching
    foreach ($URLS as $url) {
        
        if ( preg_match($url['pattern'], $uri[0], $matches) ) {
                      
            extract($matches);
            
            require_once $url['file'];
            exit();
        }
    }

    // if requested URI not matched
    
    require PROJECT_ROOT . "/404.php";
    exit();
    
?>
