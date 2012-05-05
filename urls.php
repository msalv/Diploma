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
            'pattern' => '/^\/people\/(?<username>[-_0-9a-z]{5,})\/?$/i'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/(?<profile>settings)\/?(?:profile\/?)?$/i'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/settings\/(?<account>account)\/?$/i'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/settings\/(?<password>password)\/?$/i'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/logout(\/(?<logout>[a-z0-9]+)|)\/?$/i'
        )
    );

?>
