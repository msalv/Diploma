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
            'pattern' => '/^\/(?<module>users)\/?$/i',
        ),
        array(
            'file' => $modules['users'],
            'pattern' => '/^\/(?<module>users)\/(?<username>[0-9a-z_-]+)\/?$/i'
        )
    );

    /**
     * Application entry point
     */
    
    $uri = $_SERVER['REQUEST_URI'];
    $matches = array();
    
    // URLs matching
    foreach ($urls as $url) {
        
        if (preg_match($url['pattern'], $uri, $matches)) {
           
            extract($matches);
            
            require_once $url['file'];
            exit();
        }
    }
    
    // if requested URI not matched
    
    if ( empty( $matches ) ) {
        header("HTTP/1.0 404 Not Found");
        require "$documentRoot/404.php";
        exit();
    }
    
?>
