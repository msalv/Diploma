<?php

require_once PROJECT_ROOT . '/core/Controller.php';

/**
 * PersonController controls users
 *
 * @author Kirill
 */
class PersonController extends Controller {
    
    public function __construct( $view ) {
        $this->_mapper = new PersonMapper();
        $this->_view = $view;
    }
    
    public function showUserInfo( $username ) {
        
        $fields = array('id', 'first_name', 'middle_name', 'last_name', 
            'gender', 'picture_url', 'date_of_birth', 'hometown', 
            'home_phone', 'work_phone', 'info', 'login');
        
        $search = array( 'login' => $username );
        
        $this->_mapper->select($fields)->where($search);
        $info = $this->_mapper->fetch();
        
        if ( !empty($info) ) {
            $data = $this->_view->prepare($info);
            $this->_view->load($data);
        }
        else {
            echo "User $username not found :("; // throw 404
        }
    }
    
    public function showUserList( $start = 0, $options = null ) {
        
        $fields = array('id', 'first_name', 'middle_name', 'last_name', 
            'gender', 'picture_url', 'hometown', 'login');
        
        $this->_mapper->select($fields)->orderBy('id')->limit($start, 30);
        
        $info = $this->_mapper->fetch();
        
        if ( !empty($info) ) {
            $data = $this->_view->prepare($info);
            $this->_view->load($data);
        }
        else {
            echo "User list is empty :("; // throw 404
        }
        
    }
}