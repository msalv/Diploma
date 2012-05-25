<?php

require_once PROJECT_ROOT . '/core/Mapper.php';
require_once MESSAGES_ROOT . '/Message.php';

/**
 * Description of BlogMapper
 *
 * @author Kirill
 */
class MessageMapper extends Mapper {
    
    public function save($data) {
        
        $sql = "INSERT INTO messages 
            (author_id, recipient_id, subject, content, pub_date) 
            VALUES (:author_id, :recipient_id, :subject, :content, NOW())";
        
        $STH = $this->_DBH->prepare($sql);
        
        $STH->execute($data);
    }
    
    /**
     * Fetch message by id
     * @param integer $msg_id Message id
     * @param integer $user_id User id
     * @return array Array of Message 
     */
    public function fetch() {
        $sql = "SELECT m.id, m.author_id, m.recipient_id, m.subject, m.content, m.pub_date,
            concat(p.first_name, ' ', p.last_name) AS author_name, p.login AS author_login, 
            p.picture_url AS author_pic, p.gender AS author_gender, m.unread 
            FROM people AS p, messages AS m 
            WHERE m.id=:msg_id AND ((m.author_id=:user_id AND p.id=m.author_id) 
            OR (m.recipient_id=:user_id AND p.id=m.author_id))";
        
        $STH = $this->_DBH->prepare($sql);
        $STH->setFetchMode(PDO::FETCH_CLASS, 'Message');
        
        $STH->execute( $this->_params );
        
        $msg = $STH->fetchAll();
        
        $this->clear();
        
        if ( empty($msg) ) {
            header("HTTP/1.0 404 Not Found");
            die("Page not found");
        }
        else {
            return $msg;
        }
    }
    
    public function update() {
        
        $sql = "UPDATE messages" . $this->_set . $this->_where;
        
        $STH = $this->_DBH->prepare($sql);
        
        $STH->execute($this->_params);
        
        $this->clear();
    }
    
    public function delete($modelObject) {
        // TODO: deletion
    }
    
    /**
     * Fetch inbox
     * @param integer $user_id User id
     * @param integer $start Offset
     * @param integer $amount Amount of messeges to fetch
     * @return array Array of Message 
     */
    public function fetchInbox($user_id, $start, $amount) {
        
        $sql = "SELECT m.id, m.author_id, m.recipient_id, m.subject, m.pub_date,
            concat(p.first_name, ' ', p.last_name) AS author_name, p.login AS author_login, 
            p.picture_url AS author_pic, p.gender AS author_gender, m.unread 
            FROM people AS p, messages AS m 
            WHERE m.recipient_id=:user_id AND p.id=m.author_id 
            ORDER BY m.pub_date DESC 
            LIMIT $start, $amount";
        
        $STH = $this->_DBH->prepare($sql);
        $STH->setFetchMode(PDO::FETCH_CLASS, 'Message');
        
        $STH->execute( array('user_id' => $user_id) );
        
        return $STH->fetchAll();
    }
    
    /**
     * Fetch outbox
     * @param integer $user_id User id
     * @param integer $start Offset
     * @param integer $amount Amount of messeges to fetch
     * @return array Array of Message 
     */
    public function fetchOutbox($user_id, $start, $amount) {
        
        $sql = "SELECT m.id, m.author_id, m.recipient_id, m.subject, m.pub_date,
            concat(p.first_name, ' ', p.last_name) AS author_name, p.login AS author_login, 
            p.picture_url AS author_pic, p.gender AS author_gender, m.unread 
            FROM people AS p, messages AS m 
            WHERE m.author_id=:user_id AND p.id=m.recipient_id 
            ORDER BY m.pub_date DESC 
            LIMIT $start, $amount";
        
        $STH = $this->_DBH->prepare($sql);
        $STH->setFetchMode(PDO::FETCH_CLASS, 'Message');
        
        $STH->execute( array('user_id' => $user_id) );
        
        return $STH->fetchAll();
    }
    
    public function fetchRecipientInfo($id) {
        
        $sql = "SELECT id, login, first_name, middle_name, last_name, gender, picture_url 
            FROM people WHERE id=:id";
        
        $STH = $this->_DBH->prepare($sql);
        
        require_once PROJECT_ROOT . '/modules/people/Person.php';
        $STH->setFetchMode(PDO::FETCH_CLASS, 'Person');
        
        $STH->execute( array('id' => $id) );
        
        return $STH->fetchAll();
    }
    
    public function fetchCounter($id) {
        
        $sql = "SELECT count(*) AS num
            FROM messages WHERE recipient_id=:id AND unread='1'";
        
        $STH = $this->_DBH->prepare($sql);
                
        $STH->execute( array('id' => $id) );
        
        return $STH->fetch(PDO::FETCH_ASSOC);
        
    }

}
