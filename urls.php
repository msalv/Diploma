<?php

    // Enabled modules
    $modules = array(
        'home' => PROJECT_ROOT . "/modules/hello/hello.php",
        'people' => PROJECT_ROOT . "/modules/people/people.php"
    );

    /**
     * URL patterns 
     */
    $URLS = array(
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

?>
