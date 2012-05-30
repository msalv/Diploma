<?php

require_once PROJECT_ROOT . '/core/Mapper.php';
require_once PEOPLE_ROOT . '/Person.php';

/**
 * PersonMapper is an abstract layer between DB and Person objects
 *
 * @author Kirill
 */
class PersonMapper extends Mapper {

    public function save($modelObject) {
        
    }
    
    public function fetch() {
              
        $sql = "SELECT $this->_select FROM people"
                . $this->_where
                . $this->_order
                . $this->_limit;
              
        // Prepare and execute statement fetching to Person class
        $STH = $this->_DBH->prepare($sql);
        $STH->setFetchMode(PDO::FETCH_CLASS, 'Person');
        
        $STH->execute($this->_params);
        
        $this->clear();
        
        return $STH->fetchAll();
    }
    
    public function update() {
        
        $sql = "UPDATE people" . $this->_set . $this->_where;
        
        $STH = $this->_DBH->prepare($sql);
        
        $STH->execute($this->_params);
        
        $this->clear();
    }
    
    public function delete($modelObject) {
        
    }
    
    public function updateLastLogin($login) {
        $STH = $this->_DBH
                ->prepare("UPDATE people SET last_login=CURRENT_TIMESTAMP WHERE login=:login");
        
        $STH->execute( array('login' => $login) );
    }
    
    /**
     * Checks friendship between user with username and user with id
     * @param string $username Page owner
     * @param string $id Page visitor
     * @return boolean True on success or False on failure
     */
    public function friends($username, $id) {
        $STH = $this->_DBH
                ->prepare("SELECT 1 FROM people, friends 
                    WHERE people.login=:login AND people.id=friends.f2 
                    AND friends.f1=:visitor_id");
        
        $STH->execute( array('login' => $username, 'visitor_id' => $id) );
        
        $friendship = $STH->fetch(PDO::FETCH_ASSOC);
        
        return !empty( $friendship );
    }
    
    /**
     * Fetching user friends
     * @param string $username Person's username
     * @param integer $start Fetching offset
     * @param integer $amount Amount of friends
     * @return array Array of friends
     */
    public function fetchFriends($username, $start, $amount) {
        $sql = "SELECT people.id, people.first_name, people.last_name, 
            people.login, picture_url, gender, location 
            FROM people, (SELECT friends.f2 FROM people, friends 
                WHERE people.login=:login AND people.id=friends.f1) AS R 
            WHERE R.f2=people.id ORDER BY last_name LIMIT $start, $amount";
        
        $STH = $this->_DBH->prepare($sql);
        
        $STH->setFetchMode(PDO::FETCH_CLASS, 'Person');
        
        $STH->execute( array('login' => $username) );
        
        return $STH->fetchAll();
    }
    
    public function fetchRequests($id, $start, $amount) {
        $sql = "SELECT people.id, first_name, last_name, login, picture_url, gender, R.message as info
            FROM people, (SELECT RF.requester_id, RF.message FROM people, requests_friends as RF 
                WHERE people.id=:id AND people.id=RF.target_id AND RF.approved<>'1') AS R 
            WHERE R.requester_id=people.id ORDER BY last_name LIMIT $start, $amount";
        
        $STH = $this->_DBH->prepare($sql);
        
        $STH->setFetchMode(PDO::FETCH_CLASS, 'Person');
        
        $STH->execute( array('id' => $id) );
        
        return $STH->fetchAll();
    }
    
    /**
     * Removes person with target_id from req_id person's friendlist
     * @param integer $req_id Requester id
     * @param integer $target_id Target user id
     */
    public function removePersonFromFriends($req_id, $target_id) {
        $sql = "DELETE FROM friends WHERE (f1=:target_id OR f1=:req_id) AND (f2=:target_id OR f2=:req_id)";
        
        $STH = $this->_DBH->prepare($sql);
        
        $STH->execute( array(
            'req_id' => $req_id, 
            'target_id' => $target_id
            )
        );
    }
    
    /**
     * Inserting new row into requests_friends table
     * @param integer $req_id Requester id
     * @param integer $target_id Target user id
     * @param string $msg Request message
     */
    public function makeRequest($req_id, $target_id, $msg) {
        $sql = "INSERT INTO requests_friends 
                    SELECT :req_id, id, :msg, 0 
                    FROM people WHERE id=:target_id AND id<>:req_id";
        
        $STH = $this->_DBH->prepare($sql);
        
        $STH->execute( array(
            'req_id' => $req_id, 
            'target_id' => $target_id,
            'msg' => $msg,
            ) 
        );
    }
    
    public function approveRequest($req_id, $target_id, $approve) {
        
        $params = array(
            'req_id' => $req_id, 
            'target_id' => $target_id
        );
        
        if ($approve) {
            
            // approve
            $sql = "UPDATE requests_friends SET approved='1' 
                WHERE (requester_id=:req_id AND target_id=:target_id) 
                OR (requester_id=:target_id AND target_id=:req_id)";
            
            $STH = $this->_DBH->prepare($sql);
            $STH->execute($params);
            
            // first friend
            $sql = "INSERT INTO friends 
                    SELECT :target_id, id 
                    FROM people WHERE id=:req_id AND id<>:target_id";
            
            $STH = $this->_DBH->prepare($sql);
            $STH->execute($params);
            
            // second friend
            $sql = "INSERT INTO friends 
                    SELECT id, :target_id 
                    FROM people WHERE id=:req_id AND id<>:target_id";
            
            $STH = $this->_DBH->prepare($sql);
            $STH->execute($params);
        }
        else {
            // delete from requests_friends
            $sql = "DELETE FROM requests_friends 
                WHERE (requester_id=:req_id AND target_id=:target_id) 
                OR (requester_id=:target_id AND target_id=:req_id)";
            
            $STH = $this->_DBH->prepare($sql);
            $STH->execute($params);
        }
        
    }
    
    /**
     * Fetching posts from subscribed blogs
     * @param integer $id User id
     * @param integet $start Offset
     * @param integer $amount Amount of posts
     * @return array Array of Post objects
     */
    public function fetchFeed($id, $start, $amount) {
        $sql = "SELECT p.id AS author_id, concat(p.first_name, ' ', p.last_name) AS author_name, p.login AS author_login, 
            p.picture_url AS author_pic, p.gender AS author_gender, blogs.title AS blog_title, 
            posts.id AS id, posts.title, posts.content, posts.pub_date, 
            posts.enabled, posts.comm_num, blogs.id AS blog_id 
            FROM posts, blogs, subscribers_blog AS sb, people AS p, owners_blog AS ob 
            WHERE 
                sb.subscriber_id=:user_id 
                AND sb.blog_id=blogs.id 
                AND blogs.id=posts.blog_id 
                AND posts.author_id=p.id 
                AND ( blogs.type<>'1' OR (
                    blogs.type='1' 
                    AND ob.owner_id=posts.author_id 
                    AND ob.blog_id=blogs.id) 
                )
            GROUP BY posts.id 
            ORDER BY posts.pub_date DESC
            LIMIT $start, $amount";
        
        $STH = $this->_DBH->prepare($sql);
        
        require_once PROJECT_ROOT . '/modules/blogs/Post.php';
        $STH->setFetchMode(PDO::FETCH_CLASS, 'Post');
        
        $STH->execute( array('user_id' => $id) );
        
        return $STH->fetchAll();
    }
    
    public function fetchSchedules($id) {
        
        $sql = "SELECT id, title, type, schedule 
            FROM blogs, subscribers_blog AS sb 
            WHERE sb.subscriber_id=:id AND type='3' 
            AND id=sb.blog_id;";
        
        $STH = $this->_DBH->prepare($sql);
        
        require_once PROJECT_ROOT . '/modules/blogs/Blog.php';
        $STH->setFetchMode(PDO::FETCH_CLASS, 'Blog');
        
        $STH->execute( array('id' => $id) );
        
        return $STH->fetchAll();
        
    }
    
    /**
     * Fetching blogs wich user subscribed to or owner of
     * @param integer $id User id
     * @param integer $start Offset
     * @param integer $amount Amount og blogs
     * @return array Array of blogs
     */
    public function fetchBlogs($login, $start, $amount) {
        $sql = "SELECT blogs.id, blogs.title, blogs.info 
            FROM blogs, subscribers_blog AS sb, owners_blog AS ob, people AS p 
            WHERE p.login=:login AND ((sb.subscriber_id=p.id AND blogs.id=sb.blog_id) 
                OR (ob.owner_id=p.id AND blogs.id=ob.blog_id)) AND blogs.type<>'1'
            GROUP BY blogs.id 
            LIMIT $start, $amount";
        
        $STH = $this->_DBH->prepare($sql);
        
        require_once PROJECT_ROOT . '/modules/blogs/Blog.php';
        $STH->setFetchMode(PDO::FETCH_CLASS, 'Blog');
        
        $STH->execute( array('login' => $login) );
        
        return $STH->fetchAll();
    }
    
    
    /**
     * Fetch most recent events
     * @param integer $user_id User id
     * @param integer $amount Amount of events to fetch
     * @return array Array of Event
     */
    public function fetchEvents($user_id, $amount) {
        $sql = "SELECT e.id, e.blog_id, e.start_date, e.info FROM events AS e, subscribers_blog AS sb 
            WHERE e.start_date >= now() AND e.blog_id=sb.blog_id AND sb.subscriber_id=:user_id 
            ORDER BY e.start_date 
            LIMIT 0, $amount";
        
        $STH = $this->_DBH->prepare($sql);
        
        require_once PROJECT_ROOT . '/modules/blogs/Event.php';
        $STH->setFetchMode(PDO::FETCH_CLASS, 'Event');
        
        $STH->execute( array('user_id' => $user_id) );
        
        return $STH->fetchAll();
    }
}

