<?php

if ( !defined('BLOGS_ROOT') ) {
    define('BLOGS_ROOT', PROJECT_ROOT . '/modules/blogs');
}

require_once PROJECT_ROOT . '/core/Controller.php';
require_once PROJECT_ROOT . '/core/XMLViewLoader.php';
require_once BLOGS_ROOT . '/BlogMapper.php';

/**
 * Description of BlogController
 *
 * @author Kirill
 */
class BlogController extends Controller {
    
    public function __construct( $view ) {
        $this->_mapper = new BlogMapper();
        $this->_view = new XMLViewLoader($view);
    }
    
    /**
     * Getting blog and it's posts
     * @param mixed $id Blog id or user's login
     * @param boolean $personal True if blog is personal
     * @param integer $start Offset
     * @return array Array of Blog 
     */
    public function getBlog($id, $personal = false, $start = 0) {
        
        if ($personal) {
            return $this->_mapper->getWallPosts($id, $start * 10);
        }
        else {
            return $this->_mapper->getBlogPosts($id, $start * 10);
        }
        
    }
    
    /**
     * Postring content to the user's wall
     * @param string $user User's login
     */
    public function postToWall($user) {
        $this->_checkPostData('content', 'title', 'type');
        
        if ( !empty($_POST['content']) ) {
            
            $this->_mapper->insertPost($user, $_POST['content']);
        }
    }
    
    /**
     * Getting list of blogs from the $start
     * @param integer $start Offset
     * @return array Array of Blog 
     */
    public function getBlogList($start = 0) {
        
        $fields = array('id', 'title', 'info', 'type');
        
        $this->_mapper->
                select($fields)
                ->whereNot( array( 'type' => '1' ) )
                ->orderBy('id')
                ->limit($start * 10, 30);
        
        return $this->_mapper->fetch();
    }
    
    /**
     * Performs sone action on the blog page
     * @param type $id 
     */
    public function performAction($id) {
        
        $this->_checkPostData('action', 'content', 'title', 'type');
        
        switch ($_POST['action']) {
            
            case 'subscribe':
                $this->_mapper->subscribe($id, $_SESSION['id']);
                break;
            case 'unsubscribe':
                $this->_mapper->unsubscribe($id, $_SESSION['id']);
                break;
            default:
                $this->_checkPostData('content', 'title', 'type');
                              
                // validation
                if ( empty($_POST['title']) ) {
                    die('Input title');
                }
                else if ( empty($_POST['content']) ) {
                    die('Input message');
                }
                else if ( empty($_POST['type']) ) {
                    $_POST['type'] = '1';
                }
                
                $this->_mapper->insertPost($id, $_POST['content'], $_POST['title'], $_POST['type']);

                break;
        }
        
    }
    
    /**
     * Gets subscribers of the blog
     * @param integer $blog_id Blog id
     * @param integer $start Offset
     * @param integer $amount Amount of people to get
     * @return array Array of Person 
     */
    public function getSubscribers($blog_id, $start = 0, $amount = 30) {
        return $this->_mapper->fetchSubscribers($blog_id, $start * $amount, $amount);
    }
    
    /**
     * Gets owners of the blog
     * @param integer $blog_id Blog id
     * @return array Array of Person 
     */
    public function getOwnersSettings($blog_id) {
        if ( !$this->_mapper->isOwner( $blog_id, $_SESSION['id'] ) ) {
            header('HTTP/1.0 403 Forbidden');
            die('Access denied');
        }
        
        return $this->_mapper->fetchOwners($blog_id);
    }
    
    /**
     * Gets blog settings
     * @param integer $blog_id Blog id
     * @return array Array of Blog on success 
     */
    public function getSettings($blog_id) {
        
        if ( !$this->_mapper->isOwner( $blog_id, $_SESSION['id'] ) ) {
            header('HTTP/1.0 403 Forbidden');
            die('Access denied');
        }
        
        $fields = array('id', 'title', 'info', 'type', 'locked');
        
        $search = array( 'id' => $blog_id );
        
        $this->_mapper->select($fields)->where($search);
        
        return $this->_mapper->fetch();
    }
    
    /**
     * Updates blog settrings 
     * @param integer $blog_id Blog id
     */
    public function updateSettings($blog_id) {
        
        if ( !$this->_mapper->isOwner( $blog_id, $_SESSION['id'] ) ) {
            header('HTTP/1.0 403 Forbidden');
            die('Access denied');
        }
        
        $this->_checkPostData('title', 'info', 'type', 'locked');
               
        $dom = new DOMDocument('1.0', 'utf-8');
        $dom->appendChild( new DOMElement('Blog') );
        
        $xml = simplexml_import_dom($dom);
        $xml->addChild('meta');
                
        $xml->addAttribute('id', $blog_id);
        
        if ( empty($_POST['title']) ) {
            $xml->meta[0]->addChild('message', 'Вы не указали название группы')->addAttribute('type', 'error');
        }
        
        $type = intval($_POST['type']);
        
        $xml->addChild('title', $_POST['title']);
        $xml->addChild('info', $_POST['info']);
        $xml->addAttribute('type',  ($type < 2) ? 2 : $type );
        $xml->addAttribute('locked', $_POST['locked'] == '1' ? '1' : '0');
           
        if ( !$xml->meta[0]->count() ) {
            try {
                $this->_mapper->set((array)$xml)->where( array( 'id' => $blog_id ) );
                $this->_mapper->update();
                $xml->meta[0]->addChild('message', 'Настройки группы обновлены')->addAttribute('type', 'success');
            }
            catch (PDOException $e) {
                $xml->meta[0]->addChild('message', 'При обращении к базе данных произошла ошибка')->addAttribute('type', 'error');
            }
        }
        
        // load view anyway
        $this->_view->load($dom);
    }
    
    
    /**
     * Adds new owners of the blog
     * @param integer $blog_id Blog id
     */
    public function addOwners($blog_id) {
        
        if ( !$this->_mapper->isOwner( $blog_id, $_SESSION['id'] ) ) {
            header('HTTP/1.0 403 Forbidden');
            die('Access denied');
        }
               
        if ( !empty($_POST['owners']) ) {
            
            $owners = array_unique( $_POST['owners'] );
            
            foreach ($owners as $owner) {
                
                if ( is_numeric($owner) && intval($owner) != $_SESSION['id'] ) {
                    
                    try {
                        $this->_mapper->insertOwner($blog_id, intval($owner) );
                    }
                    catch (PDOException $e) {
                        // ignore
                        //echo $e->getMessage();
                    }
                }
            } // end foreach
            
        } // end if
    }
    
    public function removeOwners($blog_id) {
        
        if ( !$this->_mapper->isOwner( $blog_id, $_SESSION['id'] ) ) {
            header('HTTP/1.0 403 Forbidden');
            die('Access denied');
        }
        
        if ( !empty($_POST['removed']) ) {
            
            $removed = array_unique( $_POST['removed'] );
            
            foreach ($removed as $owner) {
                
                if ( is_numeric($owner) && intval($owner) != $_SESSION['id'] ) {
                    
                    try {
                        $this->_mapper->deleteOwner($blog_id, intval($owner) );
                    }
                    catch (PDOException $e) {
                        // ignore
                        //echo $e->getMessage();
                    }
                }
            } // end foreach
            
        } // end if
        
    }
    
    /**
     * Validates event date entered by user
     * @param mixed $month Month of the year. Could be a string or a int
     * @param mixed $day Day of the month. Could be a string or a int
     * @param mixed $year Year. Could be a string or a int
     * @return boolean True on success or False on failure
     */
    private function _validateEventDate($month, $day, $year) {
        $month = $month ?: 0;
        $day = $day ?: 0;
        $year = $year ?: 0;
        
        return checkdate($month, $day, $year);
    }
    
    
    public function addEvent($blog_id) {
        
        if ( !$this->_mapper->isOwner( $blog_id, $_SESSION['id'] ) ) {
            header('HTTP/1.0 403 Forbidden');
            die('Access denied');
        }
        
        $this->_checkPostData('day', 'month', 'year', 'info');
       
        $dom = new DOMDocument('1.0', 'utf-8');
        $dom->appendChild( new DOMElement('Event') );
        
        $xml = simplexml_import_dom($dom);
        $xml->addAttribute('blog_id', $blog_id);
        $xml->addChild('meta');
        
        // validate info
        $xml->addChild('info', $_POST['info']);
        if ( empty($_POST['info']) ) {
            $xml->meta[0]->addChild('message', 'Укажите описание мероприятия')->addAttribute('type', 'error');
        }
        
        // date validation
        $month = $_POST['month'];
        $day = $_POST['day'];
        $year = $_POST['year'];
        
        if ( !$this->_validateEventDate($month, $day, $year) ) {
            $xml->meta[0]->addChild('message', 'Дата проведения указана неверно')->addAttribute('type', 'error');
        }
        
        // appeing date to the xml
        
        $node = $xml->addChild('start_date', "$year-$month-$day 23:59:59");
        $node->addAttribute('day', $day);
        $node->addAttribute('month', $month);
        $node->addAttribute('year', $year);
        
        // if no mistakes were made then update the database
        if ( !$xml->meta[0]->count() ) {
            try {
                $this->_mapper->attachEvent($blog_id, (array)$xml);
                $xml->meta[0]->addChild('message', 'Мероприятие добавлено')->addAttribute('type', 'success');
            }
            catch (PDOException $e) {
                $xml->meta[0]->addChild('message', 'При обращении к базе данных произошла ошибка')->addAttribute('type', 'error');
            }
        }
        
        $this->_view->load($dom);
    }
    
    /**
     * Get events
     * @param integer $blog_id Blog id
     * @param integer $amount Amount of events
     * @return array Array of Event
     */
    public function getEvents($blog_id, $amount = 5) {
        
        return $this->_mapper->fetchEvents($blog_id, $amount);
    }
    
    public function createBlog() {
        
        $this->_checkPostData('title', 'info', 'type', 'locked');
        
        $dom = new DOMDocument('1.0', 'utf-8');
        $dom->appendChild( new DOMElement('Blog') );
        
        $xml = simplexml_import_dom($dom);
        $xml->addChild('meta');
                
        $xml->addAttribute('creator_id', $_SESSION['id']);
        
        if ( empty($_POST['title']) ) {
            $xml->meta[0]->addChild('message', 'Вы не указали название группы')->addAttribute('type', 'error');
        }
        
        $type = intval($_POST['type']);
        
        $xml->addChild('title', $_POST['title']);
        $xml->addChild('info', $_POST['info']);
        $xml->addAttribute('type',  ($type < 2) ? 2 : $type );
        $xml->addAttribute('locked', $_POST['locked'] == '1' ? '1' : '0');
           
        if ( !$xml->meta[0]->count() ) {
            try {
                $this->_mapper->save((array)$xml);
                header('Location: https://' . $_SERVER['HTTP_HOST'] . '/groups');
            }
            catch (PDOException $e) {
                $xml->meta[0]->addChild('message', 'При обращении к базе данных произошла ошибка')->addAttribute('type', 'error');
                echo $e->getMessage();
            }
        }
        
        // load view anyway
        $this->_view->load($dom);
        
    }
    
    
    /**
     * Get post and all its comments
     * @param integer $id Post id
     * @return array Array of Post 
     */
    public function getPost($id) {
        return $this->_mapper->fetchPost($id);
    }
    
    
    /**
     * Posting a comment
     * @param integer $post_id Post id
     */
    public function postComment($post_id) {
        
        $this->_checkPostData('content');
        
        if ( !empty($_POST['content']) ) {
        
            try {
                $this->_mapper->insertComment($post_id, $_SESSION['id'], $_POST['content']);
            }
            catch (PDOException $e) {
                // ignore
            }
            
        }
    }
    
    public function getSchedule($blog_id) {
        
        if ( !$this->_mapper->isOwner( $blog_id, $_SESSION['id'] ) ) {
            header('HTTP/1.0 403 Forbidden');
            die('Access denied');
        }
        
        $fields = array('id', 'title', 'type', 'schedule');
        
        $search = array( 'id' => $blog_id );
        
        $this->_mapper->select($fields)->where($search);
        
        return $this->_mapper->fetch();
    }
    
    public function updateSchedule($blog_id) {
        
        $dom = new DOMDocument('1.0', 'utf-8');
        $dom->appendChild( new DOMElement('Blog') );
        
        $xml = simplexml_import_dom($dom);
        $xml->addAttribute('id', $blog_id);
        $xml->addChild('meta');
        
        if ( !empty($_FILES['xml_file']['tmp_name']) ) {
            $file = $this->_setScheduleFile($_FILES['xml_file']['tmp_name']);
            if ( empty($file) ) {
                $xml->meta[0]
                        ->addChild('message', 'Не удалось обновить расписание')
                        ->addAttribute('type', 'error');
            }
            else {
                $xml->addChild('schedule', $file);
            }
        }
        else {
            $xml->meta[0]
                ->addChild('message', 'Вы не указали файл расписания')
                ->addAttribute('type', 'error');
        }
               
        if ( !$xml->meta[0]->count() ) {
            try {
                $this->_mapper->set((array)$xml)->where( array( 'id' => $blog_id ) )->update();
                $xml->meta[0]->addChild('message', 'Расписание успешно обновлено')->addAttribute('type', 'success');
            }
            catch (PDOException $e) {
                $xml->meta[0]->addChild('message', 'При обращении к базе данных произошла ошибка')->addAttribute('type', 'error');
            }
        }
        
        $this->_view->load($dom);
        
    }
    
    private function _setScheduleFile($filename) {
        
        $doc = new DOMDocument();
        if ( !$doc->load($filename, LIBXML_NOERROR | LIBXML_NOWARNING) ) {
            return '';
        }

        $id = $_SESSION['id'];
                
        $path = PROJECT_ROOT . "/media/uploads/" . $this->_makeSubpath($id);
        
        $path .= "/schedule{$id}_" . sprintf('%x', time() );
        
        if ( !file_exists( dirname($path) ) ) {
            mkdir( dirname($path), 0755, true);
        }
        
        if ( move_uploaded_file($filename, $path) ) {
            return $path;
        }
        else {
            return '';
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
}