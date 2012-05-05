<?php

require_once PROJECT_ROOT . '/core/Controller.php';
require_once PROJECT_ROOT . '/core/ImageResizer.php';

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
    
    public function loadView($modelData = null, $rootName = null) {
        if ( !empty($modelData) ) {
            $modelData = $this->_view->prepare($modelData);
        }
        
        $this->_view->load($modelData, $rootName);
    }
    
    public function getUserInfo( $username ) {
        
        $fields = array('id', 'first_name', 'middle_name', 'last_name', 
            'gender', 'picture_url', 'date_of_birth', 'hometown', 'location',
            'home_phone', 'work_phone', 'info', 'login');
        
        $search = array( 'login' => $username );
        
        $this->_mapper->select($fields)->where($search);
        
        return $this->_mapper->fetch();
    }
    
    public function getUserList($start = 0) {
        
        $fields = array('id', 'first_name', 'middle_name', 'last_name', 
            'gender', 'picture_url', 'location', 'login');
        
        $this->_mapper->select($fields)->orderBy('id')->limit($start, 30);
        
        return $this->_mapper->fetch();
    }
    
    public function getProfileSettings() {
               
        $fields = array('id', 'first_name', 'middle_name', 'last_name', 
            'gender', 'location', 'hometown', 'date_of_birth', 
            'work_phone', 'home_phone', 'info');
        
        $search = array( 'id' => $_SESSION['id'] );
        
        $this->_mapper->select($fields)->where($search);
        
        return $this->_mapper->fetch();
    }
    
    public function getAccountSettings() {
               
        $fields = array('id', 'login', 'picture_url', 'timezone', 'gender');
        
        $search = array( 'id' => $_SESSION['id'] );
        
        $this->_mapper->select($fields)->where($search);
        
        return $this->_mapper->fetch();
    }
       
    /**
     * Validates name entered by user
     * @param string $first First name
     * @param string $middle Last name
     * @param string $last Middle name
     * @return boolean True or False
     */
    private function _validateFullName($first, $middle, $last) {
        $result = true;
        if ( !preg_match('/^[-a-zа-я]{2,}$/iu', $first) ) {
            $result = false;
        }

        if ( !preg_match('/^[-a-zа-я]+$/iu', $last) ) { // one letter last name (for asians)
            $result = false;
        }
        
        if ( !preg_match('/^([-a-zа-я]{2,}|)$/iu', $middle) ) {
            $result = false;
        }
        
        return $result;
    }
    
    /**
     * Validates birthday entered by user
     * @param mixed $month Month of the year. Could be a string or a int
     * @param mixed $day Day of the month. Could be a string or a int
     * @param mixed $year Year. Could be a string or a int
     * @return boolean True or False
     */
    private function _validateBirthday($month, $day, $year) {
        $result = true;
        $month = $month ?: 0;
        $day = $day ?: 0;
        $year = $year ?: 0;
        
        if ( checkdate($month, $day, $year) ) {
            $dob = new DateTime("$year-$month-$day");
            
            $start = date_sub(new DateTime(), new DateInterval("P90Y") ); // -90 years
            $end = date_sub(new DateTime(), new DateInterval("P13Y") ); // -13 years
                        
            //$result = ($dob < $start) ? false : ( ($dob > $end) ? false : $result);
            if ($dob < $start) {
                $result = false;
            }
            else if ($dob > $end) {
                $result = false;
            }
        }
        else {
            $result = false;
        }
        
        return $result;
    }
    
    /**
     * Checks if $_POST variable contains all required data. 
     * If data not set the function sets them to empty string. 
     */
    private function _checkPostData() {
        $keys = func_get_args();
        
        foreach ($keys as $key) {
            if ( !array_key_exists($key, $_POST) ) {
                $_POST[$key] = '';
            }
            else {
                $_POST[$key] = trim( $_POST[$key] );
            }
        }
    }

    /**
     * Generates dir/path/name based on md5($id)
     * @param string $id Base string
     * @param integer $depth Number of sub directories
     * @return string Generated subpath  
     */
    private function _makeSubpath($id, $depth = 3) {
        $hash = md5($id);
        $path = '';
        
        $depth = ($depth <= 0) ? 2 : ( ($depth >= 32) ? 31 : $depth - 1);
        
        foreach( range(0, $depth) as $n ) {
            $path .= substr($hash, $n, 2);
            $path .= ($n == $depth) ? '' : '/';
        }
        
        return $path;
    }
    
    private function _setProfilePicture($filename) {
        
        try {
            $resizer = new ImageResizer($filename);
        }
        catch (Exception $e) {
            return '';
        }

        $id = $_SESSION['id'];
        
        $path = $this->_makeSubpath($id);
        
        $resizer->resize(200);
        if ( $resizer->save(PROJECT_ROOT . "/media/userpics/$path/$id.jpg") ) {
            $resizer->resize(50);
            $resizer->crop();
            return ( $resizer->save(PROJECT_ROOT . "/media/thumbs/$path/$id.jpg") ) ? $path : '';
        }
        else {
            return '';
        }
    }

    public function updateAccount() {
        
        $this->_checkPostData("login", "timezone");
       
        $dom = new DOMDocument('1.0', 'utf-8');
        $dom->appendChild( new DOMElement('Person') );
        
        $xml = simplexml_import_dom($dom);
        $xml->addAttribute('id', $_SESSION['id']);
        $xml->addChild('meta');
        
        // login validation
        
        if ( !preg_match('/^[-_a-z0-9]{5,}$/iu', $_POST['login']) ) {
            $xml->meta[0]->addChild('message', 'Логин может состоять как минимум из пяти латинских символов и цифр')->addAttribute('type', 'error');
        }
        
        // appeing login to the xml
        $xml->addChild('login', $_POST['login']);
        
        // timezone validation
        try{
            new DateTimeZone($_POST['timezone']);
        } 
        catch(Exception $e){
            $xml->meta[0]->addChild('message', 'Часовой пояс указан не верно')->addAttribute('type', 'error');
        }
        
        $xml->addChild('timezone', $_POST['timezone']);

        // here will be a profile_picture validation
        
        if ( !empty($_FILES['profile_picture']['tmp_name']) ) {
            $picture_url = $this->_setProfilePicture($_FILES['profile_picture']['tmp_name']);
            if ( empty($picture_url) ) {
                $xml->meta[0]
                        ->addChild('message', 'Не удалось обновить фотографию')
                        ->addAttribute('type', 'error');
            }
            else {
                $xml->addChild('picture_url', $picture_url);
            }
        }
        
        // if no mistakes were made then update the database
        if ( !$xml->meta[0]->count() ) {
            try {
                $this->_mapper->set((array)$xml)->where( array( 'id' => $_SESSION['id'] ) )->update();
                $xml->meta[0]->addChild('message', 'Ваши данные успешно обновлены')->addAttribute('type', 'success');
                $_SESSION['login'] = $_POST['login'];
            }
            catch (PDOException $e) {
                if ($e->getCode() === '23000') {
                    $xml->meta[0]->addChild('message', 'Пользователь с таким логином уже существует')->addAttribute('type', 'error');
                }
                else {
                    $xml->meta[0]->addChild('message', 'При обращении к базе данных произошла ошибка')->addAttribute('type', 'error');
                }
            }
        }
        
        // load view anyway
        $this->_view->load($dom);
    }
    
    public function updatePassword() {
        
        $this->_checkPostData('currpass', 'password');
       
        $dom = new DOMDocument('1.0', 'utf-8');
        $dom->appendChild( new DOMElement('Person') );
        
        $xml = simplexml_import_dom($dom);
        $xml->addAttribute('id', $_SESSION['id']);
        $xml->addChild('meta');
        
        // current password validation
        
        $this->_mapper->select('password')->where( array('id' => $_SESSION['id']) );
        $info = $this->_mapper->fetch();
        
        if ( !$info[0]->checkPassword( $_POST['currpass'] ) ) {
            $xml->meta[0]->addChild('message', 'Ваш текущий пароль введён неверно')->addAttribute('type', 'error');
        }
        
        // new password validation
        if ( strlen($_POST['password']) < 6 ) {
            $xml->meta[0]->addChild('message', 'Новый пароль должен быть не менее шести символов')->addAttribute('type', 'error');
        }
          
        // if no mistakes were made then update the database
        if ( !$xml->meta[0]->count() ) {
            $bcrypt = new Bcrypt(13);
            $newpass = $bcrypt->hash($_POST['password']);
            try {
                $this->_mapper->set( array( 'password' => $newpass ) )
                        ->where( array( 'id' => $_SESSION['id'] ) )
                        ->update();
                $xml->meta[0]->addChild('message', 'Новый пароль успешно установлен')->addAttribute('type', 'success');
            }
            catch (PDOException $e) {
                $xml->meta[0]->addChild('message', 'При обращении к базе данных произошла ошибка')->addAttribute('type', 'error');
            }
        }
        
        // load view anyway
        $this->_view->load($dom);
    }
    
    public function updateProfile() {
        
        $this->_checkPostData("last_name", "first_name", "middle_name", 
            "day", "month", "year", "gender", "location", 
            "hometown", "work_phone", "home_phone", "info"
        );
       
        $dom = new DOMDocument('1.0', 'utf-8');
        $dom->appendChild( new DOMElement('Person') );
        
        $xml = simplexml_import_dom($dom);
        $xml->addChild('meta');
        
        // birthday validation
        
        $month = $_POST['month'];
        $day = $_POST['day'];
        $year = $_POST['year'];
        
        if ( !$this->_validateBirthday($month, $day, $year) ) {
            $xml->meta[0]->addChild('message', 'Дата рождения указана неверно')->addAttribute('type', 'error');
        }
        
        // appeing birthday to the xml
        
        $node = $xml->addChild('date_of_birth', "$year-$month-$day");
        $node->addAttribute('day', $day);
        $node->addAttribute('month', $month);
        $node->addAttribute('year', $year);
        
        // gender 'validation'
        $xml->addAttribute('gender', $_POST['gender'] == '0' ? '0' : '1');
          
        // name validation
        if ( !$this->_validateFullName($_POST['first_name'], $_POST['middle_name'], $_POST['last_name']) ) {
            $xml->meta[0]->addChild('message', 'Пишите своё имя буквами, пожалуйста')->addAttribute('type', 'error');
        }
        
        // appending full name to the xml
        $xml->addChild('first_name', $_POST['first_name']);
        $xml->addChild('last_name', $_POST['last_name']);
        $xml->addChild('middle_name', $_POST['middle_name']);
        
        // other fields don't require any validation,
        // so let them to be appended to xml just "as is"
        $xml->addChild('location', $_POST['location']);
        $xml->addChild('hometown', $_POST['hometown']);
        $xml->addChild('work_phone', $_POST['work_phone']);
        $xml->addChild('home_phone', $_POST['home_phone']);
        $xml->addChild('info', $_POST['info']);
        
        // if no mistakes were made then update the database
        if ( !$xml->meta[0]->count() ) {
            try {
                $this->_mapper->set((array)$xml)->where( array( 'id' => $_SESSION['id'] ) )->update();
                $xml->meta[0]->addChild('message', 'Ваши данные успешно обновлены')->addAttribute('type', 'success');
                $_SESSION['name'] = $_POST['first_name'] . " " . $_POST['last_name'];
            }
            catch (PDOException $e) {
                $xml->meta[0]->addChild('message', 'При обращении к базе данных произошла ошибка')->addAttribute('type', 'error');
            }
        }
        
        // load view anyway
        $this->_view->load($dom);
    }
    
    
    public function authenticate() {
        
        $dom = new DOMDocument('1.0', 'utf-8');
        $dom->appendChild( new DOMElement('meta') );
        
        if ( !empty($_POST['login']) && !empty($_POST['password']) ) {
            $login = $_POST['login'];
            $search = array( 'login' => $login );
            $this->_mapper
                    ->select('id', 'password', 'first_name', 'last_name', 'person_type')
                    ->where($search);
            
            $info = $this->_mapper->fetch();
            
            if (!empty($info)) {
                if ( $info[0]->checkPassword( $_POST['password'] ) ) {
                    $this->_mapper->updateLastLogin($login);
                    
                    ini_set('session.cookie_httponly', true);
                    
                    session_start();
                    $_SESSION['login'] = $login;
                    $_SESSION['person_type'] = $info[0]->getType();
                    $_SESSION['name'] = $info[0]->getName();
                    $_SESSION['id'] = $info[0]->getId();
                    $_SESSION['ip'] = $_SERVER['REMOTE_ADDR'];
                    
                    header("Location: http://" . $_SERVER['HTTP_HOST'] . "/people/$login/");
                }
                else {
                    $msg = $dom->appendChild( new DOMElement('message', 'Пароль не подошёл') );
                    $msg->setAttribute('type', 'error');
                }
            }
            else {
                $msg = $dom->appendChild( new DOMElement('message', 'Пользователь с таким логином у нас не числится') );
                $msg->setAttribute('type', 'error');
            }
        }
        else {
            $msg = $dom->appendChild( new DOMElement('message', 'Необходимо указать и логин, и пароль') );
            $msg->setAttribute('type', 'error');
        }
        
        $this->_view->load($dom);
    }
    
}