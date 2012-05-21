<?php

    // Enabled modules
    $modules = array(
        'home' => PROJECT_ROOT . "/modules/hello/hello.php",
        'people' => PROJECT_ROOT . "/modules/people/people.php",
        'blogs' => PROJECT_ROOT . "/modules/blogs/blogs.php",
        'upload' => PROJECT_ROOT . "/modules/uploadify/uploadify.php"
    );

    /**
     * URL patterns 
     */
    $URLS = array(
        array(
            'file' => $modules['home'],
            'pattern' => '/^\/(?<test>test)\/?$/'
        ),
        array(
            'file' => $modules['upload'],
            'pattern' => '/^\/(?<upload>upload)\/?$/'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^(?<username>)\/$/'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/(?<feed>feed)(?:\/(?<page>[1-9]+))?\/?$/'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people(?:\/(?<page>[1-9]+))?\/?$/i',
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people\/(?<username>[-_0-9a-z]{5,})\/(?<summary>profile\/?)?$/i'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people\/(?<username>[-_0-9a-z]{5,})(?:\/wall(?:\/(?<page>[1-9]+))?)?\/?$/i'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people\/(?<username>[-_0-9a-z]{5,})\/(?<friends>friends(?:\/(?<page>[1-9]+))?)?\/?$/i'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people\/(?<add>add)\/(?<id>[1-9]+)\/?$/i',
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people\/(?<remove>remove)\/(?<id>[1-9]+)\/?$/i',
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people\/friends\/(?<requests>requests)(?:\/(?<page>[1-9]+))?\/?$/i',
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people\/(?<username>[-_0-9a-z]{5,})\/(?<groups>groups(?:\/(?<page>[1-9]+))?)?\/?$/i'
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
            'pattern' => '/^\/settings\/(?<privacy>privacy)\/?$/i'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/logout(?:\/(?<logout>[a-z0-9]+)|)\/?$/i'
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups(?:\/(?<blog_id>[1-9]+))?\/?$/i',
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/(?<blog_id>[1-9]+)\/(?<subs>subscribers)(?:\/(?<page>[1-9]+))?\/?$/i',
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/(?<blog_id>[1-9]+)\/admin\/(?<settings>settings)\/?$/i',
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/(?<blog_id>[1-9]+)\/admin\/(?<owners>owners)\/?$/i',
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/(?<blog_id>[1-9]+)\/admin\/owners\/(?<owners>add)\/?$/i',
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/(?<blog_id>[1-9]+)\/admin\/owners\/(?<owners>remove)\/?$/i',
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/(?<blog_id>[1-9]+)\/admin\/(?<admin_events>events)\/?$/i',
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/(?<blog_id>[1-9]+)\/(?<events>events)\/?$/i',
        )
    );

?>
