<?php

if ( !defined('ADMIN_ROOT') ) {
    define('ADMIN_ROOT', PROJECT_ROOT . '/modules/admin');
}

require_once PROJECT_ROOT . '/core/Controller.php';
require_once PROJECT_ROOT . '/core/Bcrypt.php';
require_once PROJECT_ROOT . '/core/XMLViewLoader.php';
require_once PROJECT_ROOT . '/modules/people/PersonMapper.php';

/**
 * Description of BlogController
 *
 * @author Kirill
 */
class DocController extends Controller {
    
    public function __construct( $view ) {
        $this->_mapper = new PersonMapper();
        $this->_view = new XMLViewLoader($view);
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
    
    
    public function addUser() {
        
        $this->_checkPostData('first_name', 'last_name', 'middle_name', 'login', 'sid', 'cellphone');
        
        // outcoming xml
        $dom = new DOMDocument('1.0', 'utf-8');
        $dom->appendChild( new DOMElement('Person') );
        
        $xml = simplexml_import_dom($dom);
        $xml->addChild('meta');
        
        // name validation
        if ( !$this->_validateFullName($_POST['first_name'], $_POST['middle_name'], $_POST['last_name']) ) {
            $xml->meta[0]->addChild('message', 'Пишите имя буквами, пожалуйста')->addAttribute('type', 'error');
        }
        
        $xml->addChild('first_name', $_POST['first_name']);
        $xml->addChild('last_name', $_POST['last_name']);
        $xml->addChild('middle_name', $_POST['middle_name']);
        
        if ( !preg_match('/^[-_a-z0-9]{5,}$/iu', $_POST['login']) ) {
            $xml->meta[0]->addChild('message', 'Логин может состоять как минимум из пяти латинских символов и цифр')->addAttribute('type', 'error');
        }
        
        $xml->addChild('login', $_POST['login']);
        
        if ( !preg_match('/^[0-9]{11,}$/iu', $_POST['cellphone']) ) {
            $xml->meta[0]->addChild('message', 'Номер телефона должен состоять минимум из 11 цифр (и только цифр)')->addAttribute('type', 'error');
        }
        
        $xml->addChild('cellphone', $_POST['cellphone']);
        
        if ( empty($_POST['sid']) ) {
            $xml->meta[0]->addChild('message', 'Вы не указали номер документа')->addAttribute('type', 'error');
        }
        
        $xml->addChild('sid', $_POST['sid']);
        
        if ( empty($_POST['password']) ) {
            $xml->meta[0]->addChild('message', 'Вы не указали пароль')->addAttribute('type', 'error');
        }
       
        $xml->addChild('password', $_POST['password']);
        
        // if no mistakes were made then update the database
        if ( !$xml->meta[0]->count() ) {
            try {
                // hashing password
                $data = (array)$xml;
                $bcrypt = new Bcrypt();
                $data['password'] = $bcrypt->hash($data['password']);
                
                $this->_mapper->save($data);
                $xml->meta[0]->addChild('message', 'Регистрация успешно завершена')->addAttribute('type', 'success');
            }
            catch (PDOException $e) {             
                if ($e->getCode() === '23000') {
                    $xml->meta[0]->addChild('message', 'Пользователь с такими данными уже существует. Проверьте уникальность номера документа и логина')->addAttribute('type', 'error');
                }
                else {
                    $xml->meta[0]->addChild('message', 'При обращении к базе данных произошла ошибка')->addAttribute('type', 'error');
                }
            }
        }
        
        // load view anyway
        $this->_view->load($dom);
    }

}