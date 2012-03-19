<?php

require_once PROJECT_ROOT . '/core/Model.php';

/**
 * Person class
 *
 * @author Kirill
 */
class Person implements Model {
    private $id;
    private $sid;
    private $first_name;
    private $middle_name;
    private $last_name;
    private $login;
    private $password;
    private $picture_url;
    private $gender;
    private $work_phone;
    private $home_phone;
    private $info;
    private $date_of_birth;
    private $reg_date;
    private $hometown;
    private $timezone;
    private $person_type;
    private $privacy;
    private $last_login;
    
    /**
     * Converts object to a DOMElement
     * @param DOMElement $root Root element for returned node
     * @param array $fields Array of properties' names that needed to be fetched into an element
     */
    public function toDOMElement($root) {
                     
        $node = new DOMElement(__CLASS__);
        $root->appendChild($node);
        
        foreach ($this as $name => $value) {
            if ( !is_null($value) ) {
                switch ($name) {
                    case 'id':
                    case 'gender':
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


