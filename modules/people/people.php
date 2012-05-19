<?php

// Define current module root directory
define( 'PEOPLE_ROOT', dirname(__FILE__) );

require PEOPLE_ROOT . '/PersonController.php';

// authorization
if ( empty($_SESSION['id']) ) {
    $c = new PersonController('people/auth.xsl');
    
    if ( !empty($_POST) ) {
        $c->authenticate();
        exit();
    }

    $c->loadView();
}
// logging out
else if ( isset($logout) ) {
    if ($logout == substr(session_id(), 0, 6) ) {
        setcookie(session_name(), '', time() - 3600); // it seems doesn't work
        session_unset();
        session_destroy();
    }
    header("Location: http://" . $_SERVER['HTTP_HOST']);
}

// show feed
else if ( isset($feed) ) {

    $c = new PersonController('people/feed.xsl');
    if ( isset($page) ) {
        $feed = $c->getNewsFeed($_SESSION['id'], $page);
    }
    else {
        $feed = $c->getNewsFeed($_SESSION['id']);
    }
    $c->loadView($feed, null, true);
}
// show friends
else if ( isset($friends) ) {

    $c = new PersonController('people/friends.xsl');
    if ( isset($page) ) {
        $friends = $c->getFriends($username, $page);
    }
    else if ( isset($_GET['mode']) ) {
        $friends = $c->getFriends($username, 0, 6);
    }
    else {
        $friends = $c->getFriends($username);
    }
    $c->loadView($friends);
}
// show groups
else if ( isset($groups) ) {

    $c = new PersonController('people/groups.xsl');
    if ( isset($page) ) {
        $groups = $c->getBlogs($username, $page);
    }
    else if ( isset($_GET['mode']) ) {
        $groups = $c->getBlogs($username, 0, 15);
    }
    else {
        $groups = $c->getBlogs($username);
    }
    $c->loadView($groups);
}
// show user info
else if ( isset($summary) ) {

    $c = new PersonController('people/person.xsl');
    $info = $c->getUserInfo($username);
    $c->loadView($info);
}
// wall page
else if ( isset($username) ) {
    require_once PROJECT_ROOT . '/modules/blogs/BlogController.php';
    
    $c = new BlogController('blogs/personal.xsl');
    
    if ( empty($username) ) {
        $username = $_SESSION['username'];
    }

    if ( !empty($_POST) ) {
        $c->postToWall($username);
    }
    
    if ( isset($page) ) {
        $wall = $c->getBlog($username, true, $page);
    }
    else {
        $wall = $c->getBlog($username, true);
    }

    $c->loadView($wall);
}
// add user to friends
else if ( isset($add) ) {

    $c = new PersonController('people/add.xsl');
    if ( !empty($_POST) ) {
        $c->sendFriendRequest($id);
        exit();
    }
    else {
        $form = $c->showFriendRequest($id);
        $c->loadView($form);
    }
}
// remove user from friends
else if ( isset($remove) ) {

    $c = new PersonController('people/remove.xsl');
    if ( !empty($_POST) ) {
        $c->removeFriend($id);
        exit();
    }
    else {
        $form = $c->showRemovePage($id);
        $c->loadView($form);
    }
}
//requests
else if ( isset($requests) ) {

    $c = new PersonController('people/requests.xsl');
    if ( !empty($_POST) ) {
        $c->processRequest();
        exit();
    }
    else {
        if ( isset($page) ) {
            $form = $c->getRequests($page);
        }
        else if ( isset($_GET['mode']) ) {
            $form = $c->getRequests(0, 6);
        }
        else {
            $form = $c->getRequests();
        }
        $c->loadView($form);
    }
}
// user profile settings page
else if ( isset($profile) ) {
    
    $c = new PersonController('people/profile.xsl');
    
    if ( !empty($_POST) ) {
        $c->updateProfile();
    }
    else {
        $settings = $c->getProfileSettings();
        $c->loadView($settings);
    }
}
// user account settings page
else if ( isset($account) ) {
    
    $c = new PersonController('people/account.xsl');
    
    if ( !empty($_POST) ) {
        $c->updateAccount();
    }
    else {
        $settings = $c->getAccountSettings();
        $c->loadView($settings);
    }
}
// user password settings page
else if ( isset($password) ) {
    $c = new PersonController('people/password.xsl');
    
    if ( !empty($_POST) ) {
        $c->updatePassword();
    }
    else {
        $c->loadView(null, 'Person');
    }
}
// user privacy settings page
else if ( isset($privacy) ) {
    $c = new PersonController('people/privacy.xsl');
    
    if ( !empty($_POST) ) {
        $c->updatePrivacy();
    }
    else {
        $settings = $c->getPrivacySettings();
        $c->loadView($settings);
    }
}
// users list page
else {
    $c = new PersonController('people/people.xsl');
    
    if (isset($page) ) {
        $list = $c->getUserList($page);
        $c->loadView($list, null, true);
    }
    else {
        $list = $c->getUserList();
        $c->loadView($list);
    }
}

?>