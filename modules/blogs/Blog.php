<?php

require_once PROJECT_ROOT . '/core/Model.php';
require_once PROJECT_ROOT . '/modules/blogs/Post.php';
require_once PROJECT_ROOT . '/modules/people/Person.php';

/**
 * Description of Blog
 *
 * @author Kirill
 */
class Blog implements Model {
    private $id;
    private $title;
    private $info;
    private $type;
    private $locked;
    // following not in the table
    private $owners = array();
    private $posts = array();
    private $subscribed;
    
    public function __construct($data = null) {
        if ( !empty($data) ) {
            $this->id = $data['id'];
            $this->title = $data['title'];
            $this->info = $data['info'];
            $this->type = $data['type'];
            $this->locked = $data['locked'];
            $this->subscribed = $data['subscribed'];
            
            foreach ($data['owners'] as $p) {
                array_push($this->owners, new Person($p) );
            }
            
            foreach ($data['posts'] as $t) {
                array_push($this->posts, new Post($t) );
            }
        }
    }
    
    public function toDOMElement($root) {            
        $node = new DOMElement(__CLASS__);
        $root->appendChild($node);
        
        foreach ($this as $name => $value) {
            if ( !is_null($value) && (!empty($value) || $value == '0') ) {
                switch ($name) {
                    case 'id':
                    case 'locked':
                    case 'type':
                    case 'subscribed':
                        $node->setAttribute($name, $value);
                        break;
                    
                    case 'owners':
                        $owners = $node->appendChild( new DOMElement($name) );
                        foreach ($value as $p) {
                            $p->toDOMElement($owners);
                        }
                        break;
                        
                    case 'posts':
                        $posts = $node->appendChild( new DOMElement($name) );
                        foreach ($value as $t) {
                            $t->toDOMElement($posts);
                        }
                        break;

                    default:
                        $node->appendChild( new DOMElement($name, $value) );
                        break;
                }
            }
        }
        
        return $node;
    }
}
