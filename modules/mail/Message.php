<?php

require_once PROJECT_ROOT . '/core/Model.php';
require_once PROJECT_ROOT . '/core/Markdown.php';

/**
 * Description of Message
 *
 * @author Kirill
 */
class Message implements Model {
    private $id;
    private $author_id;
    private $recipient_id;
    private $subject;
    private $content;
    private $unread;
    private $pub_date;
    private $del_sender;
    private $del_recipient;
    // not int the table
    private $author_name;
    private $author_gender;
    private $author_pic;
    private $author_login;
    
    public function __construct() {

    }
    
    public function toDOMElement($root) {            
        $node = new DOMElement(__CLASS__);
        $root->appendChild($node);
        
        foreach ($this as $name => $value) {
            if ( !is_null($value) && (!empty($value) || $value == '0') ) {
                switch ($name) {
                    case 'id':
                    case 'author_id':
                    case 'recipient_id':
                    case 'unread':
                    case 'author_id':
                    case 'author_gender':
                        $node->setAttribute($name, $value);
                        break;
                    
                    case 'pub_date':
                        $value = $this->_shiftTime($value);
                        $date = $node->appendChild( new DOMElement($name) );
                        $date->setAttribute('day', substr($value, 8, 2));
                        $date->setAttribute('month', substr($value, 5, 2));
                        $date->setAttribute('year', substr($value, 0, 4));
                        $date->setAttribute('hour', substr($value, 11, 2));
                        $date->setAttribute('minute', substr($value, 14, 2));
                        break;
                    
                    case 'content':
                        $value = str_replace("\n", "  \n", $value);
                        $value = preg_replace('/<[^<]+>/u', '', $value);
                        $value = Markdown( $value );
                        $node->appendChild( new DOMElement($name, $value) );
                        break;
                    
                    default:
                        $node->appendChild( new DOMElement($name, $value) );
                        break;
                }
            }
        }
        
        return $node;
    }
    
    /**
     * Changes DateTime according to users timezone
     * @param string $date Formatted DateTime
     * @return string New formatted DateTime
     */
    private function _shiftTime($date) {
        $d = new DateTime($date, new DateTimeZone('Europe/Moscow'));

        try {
            $tz = new DateTimeZone($_COOKIE['timezone']);
        }
        catch (Exception $e) {
            $tz = new DateTimeZone('Europe/Moscow');
        }
        
        $d->setTimezone($tz);
        return $d->format('Y-m-d H:i:s');
    }
    
    public function isUnread() {
        return $this->unread == '1';
    }
    
    public function isAuthor($user_id) {
        return $this->author_id == $user_id;
    }
}
