<?php

require_once PROJECT_ROOT . '/core/Model.php';
require_once PROJECT_ROOT . '/core/Bcrypt.php';

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
    private $location;
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
            if ( !is_null($value) && (!empty($value) || $value == '0') ) {
                switch ($name) {
                    case 'id':
                    case 'gender':
                        $node->setAttribute($name, $value);
                        break;
                    
                    case 'date_of_birth':
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
    
    public function checkPassword($password) {
        $bcrypt = new Bcrypt(13);
        return $bcrypt->verify($password, $this->password);
    }
    
    public function getId() {
        return $this->id;
    }
    
    public function getLogin() {
        return $this->login;
    }
    
    public function getName() {
        return "$this->first_name $this->last_name";
    }
    
    public function getType() {
        return $this->person_type;
    }
}


