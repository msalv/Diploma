<?php
    /**
     * Basic configuration  
     */
    
    // Debug settings
    error_reporting(E_ALL);
    ini_set('display_errors', true);
    
    // Project root path
    define('PROJECT_ROOT', dirname(__FILE__));
    
    // Enabled modules
    $modules = array(
        'home' => PROJECT_ROOT . "/modules/hello/hello.php",
        'people' => PROJECT_ROOT . "/modules/people/people.php"
    );

    // URL patterns
    $urls = array(
        array(
            'file' => $modules['home'],
            'pattern' => '/^(?<index>\/)$/'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people\/?$/i',
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people\/(?<username>[0-9a-z_-]{3,})\/?$/i'
        )
    );

    /**
     * Application entry point
     */
    
    // split uri string by question mark
    $uri = explode("?", $_SERVER['REQUEST_URI'], 2);
    $matches = array();
    
    // URI matching
    foreach ($urls as $url) {
        
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
