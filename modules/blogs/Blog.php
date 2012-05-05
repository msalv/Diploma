<?php

require_once PROJECT_ROOT . '/core/Model.php';

/**
 * Description of Blog
 *
 * @author Kirill
 */
class Blog implements Model {
    private $id;
    private $title;
    private $info;
    private $blog_type;
    private $locked;
    
    public function toDOMElement($root) {            
        $node = new DOMElement(__CLASS__);
        $root->appendChild($node);
        
        foreach ($this as $name => $value) {
            if ( !is_null($value) && (!empty($value) || $value == '0') ) {
                switch ($name) {
                    case 'id':
                    case 'locked':
                    case 'blog_type':
                        $node->setAttribute($name, $value);
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
