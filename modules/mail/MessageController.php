<?php

if ( !defined('MESSAGES_ROOT') ) {
    define('MESSAGES_ROOT', PROJECT_ROOT . '/modules/mail');
}

require_once PROJECT_ROOT . '/core/Controller.php';
require_once PROJECT_ROOT . '/core/XMLViewLoader.php';
require_once MESSAGES_ROOT . '/MessageMapper.php';

/**
 * Description of BlogController
 *
 * @author Kirill
 */
class MessageController extends Controller {
    
    public function __construct( $view ) {
        $this->_mapper = new MessageMapper();
        $this->_view = new XMLViewLoader($view);
    }
       
    /**
     * Get message
     * @param integer $id Message id
     * @return array Array of Message on success 
     */
    public function getMessage($id) {
               
        try {
            $this->_mapper->where( array(
                'msg_id' => $id,
                'user_id' => $_SESSION['id']
            ));
            $msg = $this->_mapper->fetch();
        }
        catch (PDOException $e) {
            die('Database error');
        }
        
        // mark as read
        if ( $msg[0]->isUnread() && !$msg[0]->isAuthor($_SESSION['id']) ) {
            $this->_mapper
                    ->set( array( 'unread' => '0' ) )
                    ->where( array( 'id' => $id ) );
            $this->_mapper->update();
        }
        
        return $msg;
    }
    
    /**
     * Get inbox
     * @return array Array of Message 
     */
    public function getInbox($page = 0) {
        
        try {
            $mail = $this->_mapper->fetchInbox($_SESSION['id'], $page * 30, 30);
        }
        catch (PDOException $e) {
            die('Database error');
        }
        
        return $mail;
    }
    
    /**
     * Get outbox
     * @return array Array of Message 
     */
    public function getOutbox($page = 0) {
        
        try {
            $mail = $this->_mapper->fetchOutbox($_SESSION['id'], $page * 30, 30);
        }
        catch (PDOException $e) {
            die('Database error');
        }
        
        return $mail;
    }
    
    /**
     * Sends a private message 
     */
    public function sendMessage($recipient_id) {
        $this->_checkPostData('subject', 'content');
        
        $dom = new DOMDocument('1.0', 'utf-8');
        $dom->appendChild( new DOMElement('Person') );
        
        $xml = simplexml_import_dom($dom);
        $xml->addChild('meta');
        $xml->addAttribute('is_respond', '1');
        $xml->addAttribute('id', $recipient_id);
        
        if ( empty($_POST['content']) ) {
            $xml->meta[0]->addChild('message', 'Вы не написали текст сообщения')->addAttribute('type', 'error');
        }
        
        if ( empty($_POST['subject']) ) {
            $_POST['subject'] = null;
        }
        
        if ( !$xml->meta[0]->count() ) {
            try {
                $data = array(
                    'author_id' => $_SESSION['id'],
                    'recipient_id' => $recipient_id,
                    'subject' => $_POST['subject'],
                    'content' => $_POST['content']
                );
                $this->_mapper->save($data);
                $xml->meta[0]->addChild('message', 'Сообщение успешно отправлено')->addAttribute('type', 'success');
            }
            catch (PDOException $e) {
                $xml->meta[0]->addChild('message', 'При обращении к базе данных произошла ошибка')->addAttribute('type', 'error');
                echo $e->getMessage();
            }
        }
        
        $this->_view->load($dom);
    }
    
    
   public function showSendForm($id) {
             
       $user = $this->_mapper->fetchRecipientInfo($id);
       
       if ( empty($user) ) {
           die("User not found");
       }
       
       return $user;
   }
   
   public function getCounter() {
       
       $counter = $this->_mapper->fetchCounter($_SESSION['id']);
       
       return $counter['num'];
   }
    
}