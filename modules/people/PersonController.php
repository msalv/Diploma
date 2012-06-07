<?php

require_once PROJECT_ROOT . '/core/Controller.php';
require_once PROJECT_ROOT . '/core/XMLViewLoader.php';

require_once PEOPLE_ROOT . '/PersonMapper.php';

/**
 * PersonController controls users
 *
 * @author Kirill
 */
class PersonController extends Controller {
        
    public function __construct( $view ) {
        $this->_mapper = new PersonMapper();
        $this->_view = new XMLViewLoader($view);
    }
        
    public function getUserInfo( $username ) {
        
        $fields = array('id', 'first_name', 'middle_name', 'last_name', 
            'gender', 'picture_url', 'date_of_birth', 'hometown', 'location',
            'home_phone', 'work_phone', 'info', 'login', 
            'privacy_info', 'privacy_wall', 'privacy_friends');
        
        $search = array( 'login' => $username );
        
        $this->_mapper->select($fields)->where($search);
        
        $info = $this->_mapper->fetch();
        if ( empty($info) ) {
            header("HTTP/1.0 404 Not Found");
            die("User not found");
        }
        
        $areFriends = $this->_mapper->friends($username, $_SESSION['id']);
        $isMe = $this->isMe( $info[0]->getId() );
        
        if  ( $areFriends || $isMe ) {
            $info[0]->setPrivacyInfo(0);
            $info[0]->setPrivacyWall(0);
            $info[0]->setIsFriend(true);
        }
        
        return $info;
    }
    
    /**
     * Checks if viewer is a page owner
     * @param integer $id Page owner
     * @return boolean True on success or Fail on failure 
     */
    public function isMe($id) {
        return $_SESSION['id'] == $id;
    }
    
    /**
     * Getting friend list of $username using $start as offset
     * @param integer $username User's login
     * @param integer $start Offset
     * @return Array of Person 
     */
    public function getFriends( $username, $start = 0, $amount = 10 ) {
               
        $info = $this->getUserInfo($username);
        
        if ( empty($info) ) {
            die('User not found');
        }
        
        $areFriends = $this->_mapper->friends($username, $_SESSION['id']);
        $isMe = $this->isMe( $info[0]->getId() );
        
        if ( $areFriends || $isMe ) {
            $info[0]->setPrivacyFriends(0);
            $info[0]->setIsFriend(true);
        }
        
        // getting friends list
        $friends = $this->_mapper->fetchFriends($username, $start * $amount, $amount);
        
        $info[0]->setFriends($friends);
        
        return $info;
    }
    
    /**
     * Getting info needed to be shown when removing a friend
     * @param integer $id Target user's $id
     * @return mixed Array of Person on success, void on failure
     */
    public function showRemovePage($id) {
        
        if ( $this->isMe($id) ) {
            header("Location: http://" . $_SERVER['HTTP_HOST']);
            exit();
        }
        
        $fields = array('id', 'login', 'first_name', 'middle_name', 'last_name', 
            'gender', 'picture_url');
        
        $search = array( 'id' => $id );
        
        $this->_mapper->select($fields)->where($search);
        
        $info = $this->_mapper->fetch();
        if ( empty($info) ) {
            header("HTTP/1.0 404 Not Found");
            die("User not found");
        }
        
        if (!$this->_mapper->friends($info[0]->getLogin(), $_SESSION['id']) ) {
            
            // create simple xml with info
            $dom = new DOMDocument('1.0', 'utf-8');
            $dom->appendChild( new DOMElement('Person') );
        
            $xml = simplexml_import_dom($dom);
            
            $xml->addChild('meta');
            
            $xml->meta[0]->addChild('message', "{$info[0]->getName()} не дружит с вами")->addAttribute('type', 'info');
            $xml->meta[0]->message[0]->addChild('header', 'Вы не дружите');
            
            $this->_view->load($dom);
            
            exit();
        }
        
        return $info;
    }
    
    /**
     * Getting info needed to be shown when friend request going to be send
     * @param integer $id Target user's $id
     * @return mixed Array of Person on success, void on failure
     */
    public function showFriendRequest($id) {
        
        if ( $this->isMe($id) ) {
            header("Location: http://" . $_SERVER['HTTP_HOST']);
            exit();
        }
        
        $fields = array('id', 'login', 'first_name', 'middle_name', 'last_name', 
            'gender', 'picture_url');
        
        $search = array( 'id' => $id );
        
        $this->_mapper->select($fields)->where($search);
        
        $info = $this->_mapper->fetch();
        if ( empty($info) ) {
            header("HTTP/1.0 404 Not Found");
            die("User not found");
        }
        
        if ($this->_mapper->friends($info[0]->getLogin(), $_SESSION['id']) ) {
            
            // create simple xml with info
            $dom = new DOMDocument('1.0', 'utf-8');
            $dom->appendChild( new DOMElement('Person') );
        
            $xml = simplexml_import_dom($dom);
            
            $xml->addChild('meta');
            
            $xml->meta[0]->addChild('message', "{$info[0]->getName()} уже находится в списке ваших друзей")->addAttribute('type', 'info');
            $xml->meta[0]->message[0]->addChild('header', 'Вы уже дружите');
            
            $this->_view->load($dom);
            
            exit();
        }
        
        return $info;        
    }
    
    /**
     * Sending a friend request to user specified by $id
     * @param integer $id New possible friend's id
     */
    public function sendFriendRequest($id) {       
        // outcoming xml
        $dom = new DOMDocument('1.0', 'utf-8');
        $dom->appendChild( new DOMElement('Person') );
        
        $xml = simplexml_import_dom($dom);
        $xml->addChild('meta');
        $xml->addAttribute('is_respond', '1');
        
        if ( $this->isMe($id) ) {
            $xml->meta[0]->addChild('message', 'Дружба с самим собой? Трудное детство?')->addAttribute('type', 'success');
            $xml->meta[0]->message[0]->addChild('header', 'Вы что творите?');
            $xml->addAttribute('id', $_SESSION['id']);
            $xml->addChild('login', $_SESSION['username']);
            //$xml->addChild('picture_url', $this->_makeSubpath($id) );
            $this->_view->load($dom);
            exit();
        }
        
        // validating data
        $this->_checkPostData('message', 'login');
        
        if (strlen($_POST['message']) > 140) {
            $_POST['message'] = substr($_POST['message'], 0, 140);
        }
        
        $xml->addAttribute('id', $id);
        $xml->addChild('login', $_POST['login']);
        //$xml->addChild('picture_url', $this->_makeSubpath($id) );
        
        if ( is_numeric( $id ) ) {
            $id = intval($id);
            try {
                $this->_mapper->makeRequest( $_SESSION['id'], $id, $_POST['message'] );
                $xml->meta[0]->addChild('message', 'Ваш запрос успешно отправлен адресату')->addAttribute('type', 'success');
                $xml->meta[0]->message[0]->addChild('header', 'Заявка отправлена');
            }
            catch (PDOException $e) {
                if ($e->getCode() === '23000') {
                    $xml->meta[0]->addChild('message', 'Вы уже отправляли заявку этому человеку')->addAttribute('type', 'info');
                    $xml->meta[0]->message[0]->addChild('header', 'Внимание!');
                }
                else {
                    $xml->meta[0]->addChild('message', 'Произошла ошибка обращения к базе данных')->addAttribute('type', 'error');
                    $xml->meta[0]->message[0]->addChild('header', 'Не получилось');
                }
            }
        }
        else {
            $xml->meta[0]->addChild('message', 'Данные введены не корректно')->addAttribute('type', 'error');
            $xml->meta[0]->message[0]->addChild('header', 'Ошибка!');
        }
        
        // load view anyway
        $this->_view->load($dom);
    }
    
    /**
     * Removes person from the friend list
     * @param type $id 
     */    
    public function removeFriend($id) {       
        // outcoming xml
        $dom = new DOMDocument('1.0', 'utf-8');
        $dom->appendChild( new DOMElement('Person') );
        
        $xml = simplexml_import_dom($dom);
        $xml->addChild('meta');
        $xml->addAttribute('is_respond', '1');
              
        // validating data
        $this->_checkPostData('login');
               
        $xml->addAttribute('id', $id);
        $xml->addChild('login', $_POST['login']);
        
        // validating target user id
        if (!$this->_mapper->friends($_POST['login'], $_SESSION['id']) || $this->isMe($id) ) {
            
            $xml->meta[0]->addChild('message', "Чтобы удалить этого человека из списка друзей, сначала с ним нужно подружиться")->addAttribute('type', 'info');
            $xml->meta[0]->message[0]->addChild('header', 'Вы не дружите');
            
            $this->_view->load($dom);
            
            exit();
        }
        
        if ( is_numeric( $id ) ) {
            $id = intval($id);
            try {
                $this->_mapper->removePersonFromFriends( $_SESSION['id'], $id );
                $xml->meta[0]->addChild('message', 'Этот человек успешно удалён из вашего списка друзей')->addAttribute('type', 'success');
                $xml->meta[0]->message[0]->addChild('header', 'Пользователь удалён');
            }
            catch (PDOException $e) {
                $xml->meta[0]->addChild('message', 'Произошла ошибка обращения к базе данных')->addAttribute('type', 'error');
                $xml->meta[0]->message[0]->addChild('header', 'Не получилось');
            }
        }
        else {
            $xml->meta[0]->addChild('message', 'Данные введены не корректно')->addAttribute('type', 'error');
            $xml->meta[0]->message[0]->addChild('header', 'Ошибка!');
        }
        
        // load view anyway
        $this->_view->load($dom);
    }
    
    public function getRequests($start = 0, $amount = 10) {
        $info = $this->getUserInfo( $_SESSION['username'] );
               
        // getting friends list
        $requests = $this->_mapper->fetchRequests($_SESSION['id'], $start * 10, $amount);
        
        $info[0]->setFriends($requests);
        
        return $info;
    }
    
    public function processRequest() {
        $this->_checkPostData('id', 'approved');
        
        // outcoming xml
        $dom = new DOMDocument('1.0', 'utf-8');
        $dom->appendChild( new DOMElement('Person') );
        
        $xml = simplexml_import_dom($dom);
        $xml->addChild('meta');
        $xml->addAttribute('is_respond', '1');
        
        $xml->addAttribute('id', $_SESSION['id']);
        $xml->addChild('login', $_SESSION['username']);
        
        $approve =  ($_POST['approved'] == '1') ?: false;
        
        $id = $_POST['id'];
        
        if ( is_numeric( $id ) ) {
            $id = intval($id);
            try {
                $this->_mapper->approveRequest($id, $_SESSION['id'], $approve);
                if ($approve) {
                    $xml->meta[0]->addChild('message', 'Заявка одобрена')->addAttribute('type', 'success');
                }
                else {
                    $xml->meta[0]->addChild('message', 'Заявка отклонена')->addAttribute('type', 'info');
                }
            }
            catch (PDOException $e) {
                if ($e->getCode() === '23000') {
                    $xml->meta[0]->addChild('message', 'Вы уже дружите')->addAttribute('type', 'info');
                }
                else {
                    $xml->meta[0]->addChild('message', 'Произошла ошибка обращения к базе данных')->addAttribute('type', 'error');
                }
            }
        }
        else {
            $xml->meta[0]->addChild('message', 'Данные введены не корректно')->addAttribute('type', 'error');
        }
        
        // load view anyway
        $this->_view->load($dom);
    }


    public function getUserList($start = 0) {
        
        $fields = array('id', 'first_name', 'middle_name', 'last_name', 
            'gender', 'picture_url', 'location', 'login');
        
        $this->_mapper->select($fields)->orderBy('id')->limit($start * 10, 30);
        
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
        
        require_once PROJECT_ROOT . '/core/ImageResizer.php';
        
        try {
            $resizer = new ImageResizer($filename);
        }
        catch (Exception $e) {
            return '';
        }

        $id = $_SESSION['id'];
        
        $path = $this->_makeSubpath($id);
        
        $resizer->resize(212);
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
        else {
            switch ( $_FILES['profile_picture']['error'] ) {
                
                case UPLOAD_ERR_PARTIAL:
                    $xml->meta[0]
                        ->addChild('message', 'Загружаемое фото было получено только частично')
                        ->addAttribute('type', 'error');
                    break;
                
                case UPLOAD_ERR_INI_SIZE:
                case UPLOAD_ERR_FORM_SIZE:
                    $xml->meta[0]
                        ->addChild('message', 'Размер фотографии превысил допустимый лимит')
                        ->addAttribute('type', 'error');
                    break;
                
                
                case UPLOAD_ERR_NO_TMP_DIR:
                    $xml->meta[0]
                        ->addChild('message', 'Отсутствует временная папка')
                        ->addAttribute('type', 'error');
                    break;
                
                case UPLOAD_ERR_CANT_WRITE:
                    $xml->meta[0]
                        ->addChild('message', 'Не удалось записать файл на диск')
                        ->addAttribute('type', 'error');
                    break;
                
                case UPLOAD_ERR_EXTENSION:
                    $xml->meta[0]
                        ->addChild('message', 'PHP-расширение остановило загрузку файла')
                        ->addAttribute('type', 'error');
                    break;
                
                case UPLOAD_ERR_OK:
                case UPLOAD_ERR_NO_FILE:
                default:
                    break;
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
    
    /**
     * Gets user privacy settings
     * @return type 
     */
    public function getPrivacySettings() {
        $fields = array('id', 'login', 'privacy_wall', 'privacy_info', 'privacy_friends', 'gender');
        
        $search = array( 'id' => $_SESSION['id'] );
        
        $this->_mapper->select($fields)->where($search);
        
        return $this->_mapper->fetch();
    }
    
    /**
     * Updates user privacy settrings 
     */
    public function updatePrivacy() {
        $this->_checkPostData('wall', 'info', 'friends');
               
        $dom = new DOMDocument('1.0', 'utf-8');
        $dom->appendChild( new DOMElement('Person') );
        
        $xml = simplexml_import_dom($dom);
        $xml->addChild('meta');
                
        $xml->addAttribute('privacy_wall', $_POST['wall'] == '1' ? '1' : '0');
        $xml->addAttribute('privacy_info', $_POST['info'] == '1' ? '1' : '0');
        $xml->addAttribute('privacy_friends', $_POST['friends'] == '1' ? '1' : '0');
           
        try {
            $this->_mapper->set((array)$xml)->where( array( 'id' => $_SESSION['id'] ) );
            $this->_mapper->update();
            $xml->meta[0]->addChild('message', 'Права доступа к вашим данным обновлены')->addAttribute('type', 'success');
        }
        catch (PDOException $e) {
            $xml->meta[0]->addChild('message', 'При обращении к базе данных произошла ошибка')->addAttribute('type', 'error');
        }
        
        // load view anyway
        $this->_view->load($dom);
    }
    
    /**
     * Authenticates user
     */
    public function authenticate() {
        
        $dom = new DOMDocument('1.0', 'utf-8');
        $dom->appendChild( new DOMElement('meta') );
        
        if ( !empty($_POST['login']) && !empty($_POST['password']) ) {
            $login = $_POST['login'];
            $search = array( 'login' => $login );
            $this->_mapper
                    ->select('id', 'password', 'first_name', 'last_name', 'person_type', 'timezone', 'cellphone')
                    ->where($search);
            
            $info = $this->_mapper->fetch();
            
            if (!empty($info)) {
                if ( $info[0]->checkPassword( $_POST['password'] ) ) {
                    $this->_mapper->updateLastLogin($login);
                    
                    ini_set('session.cookie_httponly', true);
                    
                    session_start();
                    $_SESSION['username'] = $login;
                    $_SESSION['person_type'] = $info[0]->getType();
                    $_SESSION['name'] = $info[0]->getName();
                    $_SESSION['uid'] = $info[0]->getId();
                    $_SESSION['cellphone'] = $info[0]->getCellphone();
                    $_SESSION['ip'] = $_SERVER['REMOTE_ADDR'];
                    setcookie('timezone', $info[0]->getTimeZone() );
                    
                    $_SESSION['code'] =  substr( sprintf('%u', crc32( $login . '+' . time() ) ), 0, 6);
                    
                    // send SMS
                    try {
                        //$result = $this->_sendCode($_SESSION['code']);
                        //setcookie('yakoon', $result);
                        header("Location: http://" . $_SERVER['HTTP_HOST']);
                    }
                    catch (Exception $e) {
                        echo $e->getMessage();
                    }
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
    
    private function _sendCode($code) {
        
        $client = new SoapClient('http://sms.yakoon.com/sms.asmx?wsdl');
        
        return $client->Send( SMS_USER, // username
                SMS_PASS, // password's hash
                'Diploma', // sender id
                $_SESSION['cellphone'], // recipient
                '', // template
                "Vash kod: $code", // content
                '1', // format
                '', // send on
                '' // notification
        );
    }
    
    /**
     * User login verification 
     */
    public function verify() {
        $dom = new DOMDocument('1.0', 'utf-8');
        $dom->appendChild( new DOMElement('meta') );
        
        $this->_checkPostData('code');
        
        if ( !empty($_POST['code']) ) {
            
            if ($_POST['code'] == $_SESSION['code']) {
                unset($_SESSION['code']);
                
                $_SESSION['id'] = $_SESSION['uid'];
                unset($_SESSION['uid']);
                unset($_SESSION['cellphone']);
                
                $login = $_SESSION['username'];
                header("Location: http://" . $_SERVER['HTTP_HOST'] . "/people/$login/");
            }
            else {
                $msg = $dom->appendChild( new DOMElement('message', 'Вы ввели неправильный код') );
                $msg->setAttribute('type', 'error');
            }
        }
        else {
            $msg = $dom->appendChild( new DOMElement('message', 'Необходимо указать проверочный код') );
            $msg->setAttribute('type', 'error');
        }
        
        $this->_view->load($dom);
    }
    
    /**
     * Get posts from subscribed blogs
     * @param integer $id Id of the current user
     * @param integer $start Offset
     * @param integer $amount Amount of posts to get
     * @return array Array of posts 
     */
    public function getNewsFeed($id, $start = 0, $amount = 30) {
        
        return $this->_mapper->fetchFeed($id, $start * $amount, $amount);
    }
    
    
    public function getSchedules($id) {
        
        return $this->_mapper->fetchSchedules($id);
        
    }

    /**
     * Get user's subscribed blogs
     * @param integer $username Login of the user
     * @param integer $start Offset
     * @param integer $amount Amount of posts to get
     * @return array Array of blogs 
     */
    public function getBlogs($username, $start = 0, $amount = 30) {
        
        $info = $this->getUserInfo($username);
        
        if ( empty($info) ) {
            die('User not found');
        }
        
        $blogs = $this->_mapper->fetchBlogs($username, $start * $amount, $amount);
        $info[0]->setBlogs($blogs);
        
        return $info;
    }
    
    /**
     * Get events
     * @param integer $id User id
     * @param integer $amount Amount of events
     * @return array Array of event 
     */
    public function getEvents($id, $amount = 10) {
        
        return $this->_mapper->fetchEvents($id, $amount);
    }
    
}