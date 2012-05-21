<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Event
 *
 * @author Kirill
 */
class Event implements Model {
    
    private $id;
    private $blog_id;
    private $start_date;
    private $info;
    
    public function __construct($blog_id = null) {
        
        if ( !is_null($blog_id) ) {
            $this->blog_id = $blog_id;

            $d = new DateTime();
            $this->start_date = $d->format('Y-m-d');
        }
    }
    
    public function toDOMElement($root) {            
        $node = new DOMElement(__CLASS__);
        $root->appendChild($node);
        
        foreach ($this as $name => $value) {
            if ( !is_null($value) && (!empty($value) || $value == '0') ) {
                switch ($name) {
                    case 'id':
                    case 'blog_id':
                        $node->setAttribute($name, $value);
                        break;
                    
                    case 'start_date':
                        $date = $node->appendChild( new DOMElement($name) );
                        $date->setAttribute('day', substr($value, 8, 2));
                        $date->setAttribute('month', substr($value, 5, 2));
                        $date->setAttribute('year', substr($value, 0, 4));
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
