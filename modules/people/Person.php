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
    private $privacy_wall;
    private $privacy_info;
    private $privacy_friends;
    private $last_login;
    
    //not in the table
    private $friends;
    private $is_friend;
    private $blogs;
    
    public function __construct($data = null) {
        if ( !empty($data) ) {
            $this->id = $data['id'];
            $this->first_name = $data['first_name'];
            $this->last_name = $data['last_name'];
            $this->middle_name = $data['middle_name'];
            $this->picture_url = $data['picture_url'];
            $this->login = $data['login'];
            $this->gender = $data['gender'];
            $this->is_friend = $data['is_friend'];
        }
    }
    
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
                    case 'privacy_wall':
                    case 'privacy_info':
                    case 'privacy_friends':
                        $node->setAttribute($name, $value);
                        break;
                    
                    case 'date_of_birth':
                        $date = $node->appendChild( new DOMElement($name) );
                        $date->setAttribute('day', substr($value, 8, 2));
                        $date->setAttribute('month', substr($value, 5, 2));
                        $date->setAttribute('year', substr($value, 0, 4));
                        break;
                    
                    case 'friends':
                    case 'blogs':
                        $list = $node->appendChild( new DOMElement($name) );
                        foreach ($value as $i) {
                            $i->toDOMElement($list);
                        }
                        break;
                        
                    case 'is_friend':
                        if ($value) {
                            $node->appendChild( new DOMElement($name, $value) );
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
    
    public function getTimeZone() {
        return $this->timezone;
    }
    
    public function getPrivacyWall() {
        return $this->privacy_wall;
    }
    
    public function setPrivacyWall($val) {
        $this->privacy_wall = $val;
    }
    
    public function getPrivacyInfo() {
        return $this->privacy_info;
    }
    
    public function setPrivacyInfo($val) {
        $this->privacy_info = $val;
    }
    
    public function getPrivacyFriends() {
        return $this->privacy_friends;
    }
    
    public function setPrivacyFriends($val) {
        $this->privacy_friends = $val;
    }
    
    public function setFriends($friends) {
        $this->friends = $friends;
    }
    
    public function setIsFriend($val) {
        $this->is_friend = $val;
    }
    
    public function setBlogs($blogs) {
        $this->blogs = $blogs;
    }
}


