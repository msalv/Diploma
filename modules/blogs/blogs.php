<?php

// Define current module root directory
define( 'BLOGS_ROOT', dirname(__FILE__) );

require_once BLOGS_ROOT . '/BlogController.php';

// create new
if ( isset($new) ) {
    $c = new BlogController('blogs/new.xsl');
    
    if ( !empty($_POST) ) {
        $blog = $c->createBlog();
    }
    else {
        $blog = array ( new Blog() );
    }

    $c->loadView($blog);
}
// subscribers
else if ( isset($subs) ) {
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
// owners
else if ( isset($owners) ) {
    $c = new BlogController('blogs/owners.xsl');

    if ( !empty($_POST) ) {
        
        if ($owners == 'add') {
            $c->addOwners($blog_id);
        }
        else if ($owners == 'remove') {
            $c->removeOwners($blog_id);
        }
    }
    
    $blog = $c->getOwnersSettings($blog_id);

    $c->loadView($blog);
}
// admin events
else if ( isset($admin_events) ) {
    $c = new BlogController('blogs/events.xsl');

    if ( !empty($_POST) ) {
        
        $c->addEvent($blog_id);
        exit();
    }
    
    require_once PROJECT_ROOT . '/modules/blogs/Event.php';
    $event = new Event($blog_id);

    $c->loadView( array ($event) );
}
// show blog
else if ( isset($events) ) {
    $c = new BlogController('blogs/events.xsl');
   
    if ( isset( $_GET['mode']) ) {
        $events = $c->getEvents($blog_id, 3);
    }
    else {
        $events = $c->getEvents($blog_id);
    }

    $c->loadView($events, null, true);
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
// show post
else if ( isset($post_id) ) {
    $c = new BlogController('blogs/post.xsl');

    if ( !empty($_POST) ) {
        
        $c->postComment($post_id);
    }
    
    $post = $c->getPost($post_id);

    $c->loadView($post);
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
