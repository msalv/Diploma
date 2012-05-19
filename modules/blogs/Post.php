<?php

require_once PROJECT_ROOT . '/core/Model.php';
require_once PROJECT_ROOT . '/core/Markdown.php';

/**
 * Description of Post
 *
 * @author Kirill
 */
class Post implements Model {
    private $id;
    private $blog_id;
    private $author_id;
    private $title;
    private $content;
    private $pub_date;
    private $post_type;
    private $enabled;
    private $comm_num;
    // following not in the table
    private $author_name;
    private $author_login;
    private $author_pic;
    private $author_gender;
    private $blog_title;
    
    public function __construct($data = null) {
        if ( !empty($data) ) {
            $this->id = $data['id'];
            $this->content = $data['content'];
            $this->pub_date = $data['pub_date'];
            $this->author_name = $data['first_name'] . ' ' . $data['last_name'];
            $this->author_pic = $data['picture_url'];
            $this->enabled = $data['enabled'];
            $this->author_id = $data['author_id'];
            $this->author_login = $data['login'];
            $this->author_gender = $data['gender'];
            $this->comm_num = $data['comm_num'];
            $this->title = $data['title'];
        }
    }
    
    public function toDOMElement($root) {            
        $node = new DOMElement(__CLASS__);
        $root->appendChild($node);
        
        foreach ($this as $name => $value) {
            if ( !is_null($value) && (!empty($value) || $value == '0') ) {
                switch ($name) {
                    case 'id':
                    case 'enabled':
                    case 'post_type':
                    case 'blog_id':
                    case 'author_id':
                    case 'author_gender':
                    case 'comm_num':
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
}

?>
