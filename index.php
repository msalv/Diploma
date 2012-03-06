<?php
    /**
     * Basic configuration  
     */
    
    // Debug settings
    error_reporting(E_ALL);
    ini_set('display_errors', true);
    
    // Project root path
    $documentRoot = dirname(__FILE__);
    
    // Enabled modules
    $modules = array(
        'home' => "$documentRoot/modules/hello/hello.php",
        'users' => "$documentRoot/modules/users/users.php"
    );

    // URL patterns
    $urls = array(
        array(
            'file' => $modules['home'],
            'pattern' => '/^(?<index>\/)$/'
        ),
        array(
            'file' => $modules['users'],
            'pattern' => '/^\/users\/?$/i',
        ),
        array(
            'file' => $modules['users'],
            'pattern' => '/^\/users\/(?<username>[0-9a-z_-]{3,})\/?$/i'
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
        
        if (preg_match($url['pattern'], $uri[0], $matches)) {
                      
            extract($matches);
            
            require_once $url['file'];
            exit();
        }
    }
    
    // if requested URI not matched
    
    require "$documentRoot/404.php";
    exit();
    
?>
