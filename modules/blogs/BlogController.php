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
                ->where( array( 'type' => '2' ) )
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
    
}