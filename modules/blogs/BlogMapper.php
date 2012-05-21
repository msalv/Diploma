<?php

require_once PROJECT_ROOT . '/core/Mapper.php';
require_once BLOGS_ROOT . '/Blog.php';

/**
 * Description of BlogMapper
 *
 * @author Kirill
 */
class BlogMapper extends Mapper {
    
    public function save($data) {
        if ( isset($data['@attributes']) ) {
            $data = array_merge($data, $data['@attributes']);
        }
        
        unset( $data['@attributes'] );
        unset( $data['meta'] );
        
        $sql = "INSERT INTO blogs (creator_id, title, info, type, locked) 
            VALUES (:creator_id, :title, :info, :type, :locked)";
        
        $STH = $this->_DBH->prepare($sql);
        
        $STH->execute($data);
    }
    
    public function fetch() {
              
        $sql = "SELECT $this->_select FROM blogs"
                . $this->_where
                . $this->_order
                . $this->_limit;
              
        // Prepare and execute statement fetching to Person class
        $STH = $this->_DBH->prepare($sql);
        $STH->setFetchMode(PDO::FETCH_CLASS, 'Blog');
        
        $STH->execute($this->_params);
        
        $this->clear();
        
        return $STH->fetchAll();
    }
    
    public function update() {
        
        $sql = "UPDATE blogs" . $this->_set . $this->_where;
        
        $STH = $this->_DBH->prepare($sql);
        
        $STH->execute($this->_params);
        
        $this->clear();
    }
    
    public function delete($modelObject) {
        
    }
    
    public function subscribe($id, $user_id) {
        $STH = $this->_DBH->prepare("INSERT INTO subscribers_blog VALUES (:user_id, :id)");
        try {
            $STH->execute( array('id' => $id, 'user_id' => $user_id) );
        }
        catch (PDOException $e) {
            return "error";
        }
    }
    
    public function unsubscribe($id, $user_id) {
        $STH = $this->_DBH->prepare("DELETE FROM subscribers_blog 
            WHERE subscriber_id=:user_id AND blog_id=:id");
        $STH->execute( array('id' => $id, 'user_id' => $user_id) );
    }
    
    public function insertPost($id, $content, $title = null, $type = '1') {
        
        // if blog's $id is not a number then try get it as personal blog's owner login
        if ( !is_numeric($id) ) {
            $sql = "SELECT blogs.id, blogs.locked, blogs.type 
                    FROM blogs, people, owners_blog 
                    WHERE people.login=:blog 
                        AND people.id=owners_blog.owner_id 
                        AND owners_blog.blog_id=blogs.id 
                        AND blogs.type='1'";
        }
        else {
            $sql = "SELECT blogs.id, blogs.locked, blogs.type 
                    FROM blogs 
                    WHERE blogs.id=:blog";
        }
        
        $STH = $this->_DBH->prepare($sql);
        $STH->execute( array('blog' => $id) );
        
        $blog = $STH->fetch(PDO::FETCH_ASSOC);
        
        if ( empty($blog) ) {
            header("HTTP/1.0 404 Not Found");
            die("Blog not found");
        }
        
        // checking for user as a subscriber of the blog
        $can_post = true;
        
        if ($blog['locked'] == '1') {
            $can_post = $this->_isSubscriber($blog['id'], $_SESSION['id']);
        }
        
        if ( $can_post ) {
            $blog['locked'] = '0';
            
            $sql = "INSERT INTO 
                posts (blog_id, author_id, title, content, pub_date, post_type) 
                VALUES (:blog_id, :poster_id, :title, :content, NOW(), :type);";
                            
            $STH = $this->_DBH->prepare($sql);

            $STH->execute( array(
                'blog_id' => $blog['id'],
                'poster_id' => $_SESSION['id'],
                'title' => $title,
                'content' => $content,
                'type' => $type
            ) );
            
        }
    }
    
    /**
     * Checks whether user is subscriber of blog or not
     * @param integer $blog_id Blog id
     * @param integer $user_id User id
     * @return boolean True on success or False on failure
     */
    private function _isSubscriber($blog_id, $user_id) {
       
        $STH = $this->_DBH
                ->prepare("SELECT 1 as can_post FROM subscribers_blog 
                    WHERE subscriber_id=:user_id AND blog_id=:blog_id");

        $STH->execute( array('blog_id' => $blog_id, 'user_id' => $user_id) );
        
        $subscription = $STH->fetch(PDO::FETCH_ASSOC);
        
        return !empty( $subscription );
    }
    
    /**
     * Checks whether user is owner of the blog or not
     * @param integer $blog_id Blog id
     * @param integer $user_id User id
     * @return boolean True on success or False on failure
     */
    public function isOwner($blog_id, $user_id) {
        
        $STH = $this->_DBH
                ->prepare("SELECT 1 AS result FROM blogs, owners_blog 
                    WHERE id=:blog_id AND owner_id=:user_id AND blog_id=id");
        
        $STH->execute( array('blog_id' => $blog_id, 'user_id' => $user_id) );
        
        $ownership = $STH->fetch(PDO::FETCH_ASSOC);
        
        return !empty( $ownership );
    }
    
    public function getWallPosts($login, $start) {
              
        // getting wall info
        $STH = $this->_DBH
                ->prepare("SELECT blogs.id, blogs.locked, 
                    people.id AS user_id, people.first_name, people.login, people.gender, 
                    people.last_name, people.middle_name, people.picture_url 
                    FROM blogs, people, owners_blog 
                    WHERE people.login=:login 
                        AND people.id=owners_blog.owner_id 
                        AND owners_blog.blog_id=blogs.id 
                        AND blogs.type='1'");
        
        $STH->execute( array('login' => $login) );
        
        $wall = $STH->fetch(PDO::FETCH_ASSOC);
        
        if ( empty($wall) ) {
            header("HTTP/1.0 404 Not Found");
            die("Wall not found");
        }

        // checking for user as a subscriber of the blog

        if ( $this->_isSubscriber($wall['id'], $_SESSION['id']) ) {
            $wall['is_friend'] = true;
            $wall['locked'] = '0';
        }
        else {
            $wall['is_friend'] = false;
        }
        
        // if user a subscriber then get posts from the blog
        $posts = array();
        
        if ( $wall['locked'] == '0' ) {
            
            $sql = "SELECT posts.id, posts.title, posts.content, posts.pub_date, posts.enabled, 
                people.first_name, people.last_name, people.picture_url, 
                people.id AS author_id, people.login, people.gender, posts.comm_num 
                FROM posts, people 
                WHERE blog_id=:blog_id AND author_id=people.id 
                ORDER BY posts.id DESC 
                LIMIT $start, 10";
            
            $STH = $this->_DBH->prepare($sql);
            
            $STH->execute( array('blog_id' => $wall['id']) );
            
            $posts = $STH->fetchAll(PDO::FETCH_ASSOC);
        }
               
        $owner = array(
            'id' => $wall['user_id'],
            'first_name' => $wall['first_name'],
            'middle_name' => $wall['middle_name'],
            'last_name' => $wall['last_name'],
            'picture_url' => $wall['picture_url'],
            'login' => $wall['login'],
            'gender' => $wall['gender'],
            'is_friend' => $wall['is_friend']
        );
        
        $blog = array(
            'id' => $wall['id'],
            'locked' => $wall['locked'],
            'type' => 1,
            'owners' => array($owner),
            'posts' => $posts,
            'title' => null,
            'info' => null,
            'subscribed' => $wall['is_friend']
        );
        
        return array( new Blog($blog) );
    }
    
    public function getBlogPosts($blog_id, $start) {
              
        // getting blog info
        $STH = $this->_DBH
                ->prepare("SELECT id, title, info, type, locked 
                    FROM blogs WHERE id=:blog_id AND type<>'1'");
        
        $STH->execute( array('blog_id' => $blog_id) );
        
        $blog = $STH->fetch(PDO::FETCH_ASSOC);
        
        if ( empty($blog) ) {
            header("HTTP/1.0 404 Not Found");
            die("Blog not found");
        }
       
        if ( $this->_isSubscriber($blog_id, $_SESSION['id']) ) {
            $blog['subscribed'] = true;
            $blog['locked'] = '0';
        }
        else {
            $blog['subscribed'] = false;
        }
        
        // if user a subscriber then get posts from the blog
        $posts = array();
        
        if ( $blog['locked'] == '0' ) {
           
            $sql = "SELECT posts.id, posts.title, posts.content, posts.pub_date, posts.enabled, 
                people.first_name, people.last_name, people.gender, people.picture_url, 
                people.id AS author_id, people.login, posts.comm_num 
                FROM posts, people 
                WHERE blog_id=:blog_id AND author_id=people.id 
                ORDER BY posts.id DESC 
                LIMIT $start, 10";
            
            $STH = $this->_DBH->prepare($sql);
            
            $STH->execute( array('blog_id' => $blog_id) );
            
            $posts = $STH->fetchAll(PDO::FETCH_ASSOC);
        }
                     
        $blog['posts'] = $posts;
        
        // getting owners
        $STH = $this->_DBH->prepare("SELECT id, login, first_name, middle_name, 
            last_name, picture_url, gender, 1 AS is_friend 
            FROM people, owners_blog WHERE people.id=owners_blog.owner_id 
            AND owners_blog.blog_id=:blog_id");
        
        $STH->execute( array('blog_id' => $blog_id) );
        
        $owners = $STH->fetchAll(PDO::FETCH_ASSOC);
        
        $blog['owners'] = $owners;
        
        return array( new Blog($blog) );
    }
    
    /**
     * Fetch $amount subscribers of the $blog_id from $start
     * @param integer $blog_id Blog Id
     * @param integer $start Fetching offset
     * @param integer $amount Amount of people to fetch
     * @return array Array of Person
     */
    public function fetchSubscribers($blog_id, $start, $amount) {
        
        $STH = $this->_DBH->prepare(
                "SELECT id, login, first_name, middle_name, 
                    last_name, picture_url, gender, location 
                FROM people, subscribers_blog AS sb 
                WHERE people.id=sb.subscriber_id 
                AND sb.blog_id=:blog_id 
                LIMIT $start, $amount");
        
        $STH->setFetchMode(PDO::FETCH_CLASS, 'Person');
        $STH->execute( array('blog_id' => $blog_id) );
        
        return $STH->fetchAll();
    }
    
    /**
     * Fetch owners of the $blog_id
     * @param integer $blog_id Blog Id
     * @return array Array of Blog
     */
    public function fetchOwners($blog_id) {
        
        $STH = $this->_DBH->prepare("SELECT id, login, first_name, middle_name, 
            last_name, picture_url, gender, 1 AS is_friend 
            FROM people, owners_blog WHERE people.id=owners_blog.owner_id 
            AND owners_blog.blog_id=:blog_id");
        
        $STH->execute( array('blog_id' => $blog_id) );
        
        $owners = $STH->fetchAll(PDO::FETCH_ASSOC);
        
        $blog = array(
            'id' => $blog_id,
            'title' => null,
            'info' => null,
            'type' => null,
            'locked' => 0,
            'subscribed' => 1,
            'posts' => array(),
            'owners' => $owners
        );
        
        return array( new Blog($blog) );
    }
    
    /**
     * Inserts new owner
     * @param integer $blog_id Blog id
     * @param integer $owner_id New owner id
     */
    public function insertOwner($blog_id, $owner_id) {
        
        $STH = $this->_DBH
                ->prepare("INSERT INTO owners_blog(owner_id, blog_id) 
                    VALUES (:owner_id, :blog_id)");
        
        $STH->execute( array('owner_id' => $owner_id, 'blog_id' => $blog_id) );
    }
    
    /**
     * Deletes new owner
     * @param integer $blog_id Blog id
     * @param integer $owner_id New owner id
     */
    public function deleteOwner($blog_id, $owner_id) {
        
        $STH = $this->_DBH
                ->prepare("DELETE FROM owners_blog 
                    WHERE owner_id=:owner_id AND blog_id=:blog_id");
        
        $STH->execute( array('owner_id' => $owner_id, 'blog_id' => $blog_id) );
    }
    
    /**
     * Attachs event to the blog
     * @param integer $blog_id Blog id
     * @param array $data Event data
     */
    public function attachEvent($blog_id, $data) {
        $STH = $this->_DBH
            ->prepare("INSERT INTO events(blog_id, start_date, info) 
                VALUES (:blog_id, :start_date, :info)");
        
        $STH->execute( array(
            'blog_id' => $blog_id, 
            'start_date' => $data['start_date'],
            'info' => $data['info']
        ) );
    }
    
    /**
     * Fetch most recent events attached to the blog
     * @param integer $blog_id Blog Id
     * @param integer $amount Amount of events
     * @return array Array of Event 
     */
    public function fetchEvents($blog_id, $amount) {
        
        $STH = $this->_DBH
            ->prepare("SELECT id, blog_id, start_date, info FROM events 
                WHERE blog_id=:blog_id AND start_date >= now()
                ORDER BY start_date 
                LIMIT 0, $amount");
               
        require_once BLOGS_ROOT . '/Event.php';
        $STH->setFetchMode(PDO::FETCH_CLASS, 'Event');
        $STH->execute( array('blog_id' => $blog_id) );
        
        return $STH->fetchAll();
    }

}
