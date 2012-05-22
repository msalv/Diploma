<?php

require_once PROJECT_ROOT . '/core/Model.php';

/**
 * Description of Doc
 *
 * @author Kirill
 */
class Doc implements Model {
    private $id;
    private $user_id;
    private $url;
    private $name;
    private $upload_date;
    
    public function __construct() {

    }
    
    public function toDOMElement($root) {            
        $node = new DOMElement(__CLASS__);
        $root->appendChild($node);
        
        foreach ($this as $name => $value) {
            if ( !is_null($value) && (!empty($value) || $value == '0') ) {
                switch ($name) {
                    case 'id':
                    case 'user_id':
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
