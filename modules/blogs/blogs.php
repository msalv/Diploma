<?php

// Define current module root directory
define( 'BLOGS_ROOT', dirname(__FILE__) );

require_once BLOGS_ROOT . '/BlogController.php';

if ( isset($subs) ) {
    $c = new BlogController('blogs/subs.xsl');
      
    if ( isset($page) ) {
        $people = $c->getSubscribers($blog_id, $page);
    }
    else if ( isset($_GET['mode']) ) {
        if ($_GET['mode'] == 'block') {
            $people = $c->getSubscribers($blog_id, 0, 6);
        }
        else {
            $people = $c->getSubscribers($blog_id);
        }
    }
    else {
        $people = $c->getSubscribers($blog_id);
    }

    $c->loadView($people, null, true);
}
// settings
else if ( isset($settings) ) {
    $c = new BlogController('blogs/settings.xsl');

    if ( !empty($_POST) ) {
        
        $c->updateSettings($blog_id);
        exit();
    }
    
    $blog = $c->getSettings($blog_id);

    $c->loadView($blog);
}
// show blog
else if ( isset($blog_id) ) {
    $c = new BlogController('blogs/casual.xsl');

    if ( !empty($_POST) ) {
        
        $c->performAction($blog_id);
    }
    
    $blog = $c->getBlog($blog_id);

    $c->loadView($blog);
}
else {
    $c = new BlogController('blogs/blogs.xsl');
    
    if (isset($page) ) {
        $list = $c->getBlogList($page);
        $c->loadView($list, null, true);
    }
    else {
        $list = $c->getBlogList();
        $c->loadView($list);
    }
}
