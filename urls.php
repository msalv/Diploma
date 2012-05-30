<?php

    // Enabled modules
    $modules = array(
        'home' => PROJECT_ROOT . "/modules/hello/hello.php",
        'people' => PROJECT_ROOT . "/modules/people/people.php",
        'blogs' => PROJECT_ROOT . "/modules/blogs/blogs.php",
        'uploads' => PROJECT_ROOT . "/modules/uploads/uploads.php",
        'mail' => PROJECT_ROOT . "/modules/mail/mail.php",
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
            'file' => $modules['uploads'],
            'pattern' => '/^\/(?<uploads>uploads)\/?$/'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^(?<username>)\/$/'
        ),
        array(
            'file' => $modules['mail'],
            'pattern' => '/^\/mail(?:\/(?<page>[^0]?[0-9]+))?\/?$/'
        ),
        array(
            'file' => $modules['mail'],
            'pattern' => '/^\/mail\/(?<counter>counter)\/?$/'
        ),
        array(
            'file' => $modules['mail'],
            'pattern' => '/^\/mail\/(?<outbox>outbox)(?:\/(?<page>[^0]?[0-9]+))?\/?$/'
        ),
        array(
            'file' => $modules['mail'],
            'pattern' => '/^\/mail\/msg(?<msg>[^0]?[0-9]+)\/?$/'
        ),
        array(
            'file' => $modules['mail'],
            'pattern' => '/^\/mail\/to\/(?<to>[^0]?[0-9]+)\/?$/'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/(?<feed>feed)(?:\/(?<page>[^0]?[0-9]+))?\/?$/'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/(?<schedules>schedules)\/?$/'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people(?:\/(?<page>[^0]?[0-9]+))?\/?$/i',
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people\/(?<username>[-_0-9a-z]{5,})\/(?<summary>profile\/?)?$/i'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people\/(?<username>[-_0-9a-z]{5,})(?:\/wall(?:\/(?<page>[^0]?[0-9]+))?)?\/?$/i'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people\/(?<username>[-_0-9a-z]{5,})\/(?<friends>friends(?:\/(?<page>[^0]?[0-9]+))?)?\/?$/i'
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people\/(?<add>add)\/(?<id>[^0]?[0-9]+)\/?$/i',
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people\/(?<remove>remove)\/(?<id>[^0]?[0-9]+)\/?$/i',
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people\/friends\/(?<requests>requests)(?:\/(?<page>[^0]?[0-9]+))?\/?$/i',
        ),
        array(
            'file' => $modules['people'],
            'pattern' => '/^\/people\/(?<username>[-_0-9a-z]{5,})\/(?<groups>groups(?:\/(?<page>[^0]?[0-9]+))?)?\/?$/i'
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
            'pattern' => '/^\/groups(?:\/(?<blog_id>[^0]?[0-9]+))?\/?$/i'
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/(?<blog_id>[^0]?[0-9]+)\/(?<subs>subscribers)(?:\/(?<page>[^0]?[0-9]+))?\/?$/i'
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/(?<blog_id>[^0]?[0-9]+)\/admin\/(?<settings>settings)\/?$/i'
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/(?<blog_id>[^0]?[0-9]+)\/admin\/(?<owners>owners)\/?$/i'
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/(?<blog_id>[^0]?[0-9]+)\/admin\/owners\/(?<owners>add)\/?$/i'
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/(?<blog_id>[^0]?[0-9]+)\/admin\/owners\/(?<owners>remove)\/?$/i'
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/(?<blog_id>[^0]?[0-9]+)\/admin\/(?<admin_events>events)\/?$/i'
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/(?<blog_id>[^0]?[0-9]+)\/admin\/(?<schedule>schedule)\/?$/i'
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/(?<blog_id>[^0]?[0-9]+)\/(?<events>events)\/?$/i'
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/(?<new>new)\/?$/i'
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/people\/[-_a-z0-9]{5,}\/wall\/post\/(?<post_id>[^0]?[0-9]+)\/?$/i'
        ),
        array(
            'file' => $modules['blogs'],
            'pattern' => '/^\/groups\/[-_a-z0-9]+\/post\/(?<post_id>[^0]?[0-9]+)\/?$/i'
        )
    );

?>
