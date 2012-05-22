<?php

if ( !defined('UPLOADS_ROOT') ) {
    define('UPLOADS_ROOT', PROJECT_ROOT . '/modules/uploads');
}

require_once PROJECT_ROOT . '/core/Controller.php';
require_once PROJECT_ROOT . '/core/XMLViewLoader.php';
require_once UPLOADS_ROOT . '/DocMapper.php';

/**
 * Description of BlogController
 *
 * @author Kirill
 */
class DocController extends Controller {
    
    public function __construct( $view ) {
        $this->_mapper = new DocMapper();
        $this->_view = new XMLViewLoader($view);
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
    
    public function uploadDoc() {
        
        if ( isset($_FILES['doc']) ) {
        
            // make subpath
            $id = $_SESSION['id'];
            $path = $this->_makeSubpath($id);

            // determine file extension
            $realname = $_FILES['doc']['name'];
            $path_parts = pathinfo($realname);
                      
            $ext = isset($path_parts['extension']) ?
                '.' . $path_parts['extension'] :
                "";
            
            // make 'random' filename
            $filename = 'doc' . $id . '_' . sprintf('%x', crc32( $realname . time() ) );
            $url = "/media/uploads/$path/$filename" . $ext;
            $savepath = PROJECT_ROOT . $url;

            // check if dir exists
            if ( !file_exists( dirname($savepath) ) ) {
                mkdir( dirname($savepath), 0755, true);
            }

            if ( move_uploaded_file($_FILES['doc']['tmp_name'], $savepath) ) {
                
                $data = array(
                    'user_id' => $id,
                    'url' => $url,
                    'name' => $realname
                );
                
                try {
                    $this->_mapper->save($data);
                }
                catch (PDOException $e) {
                    die('Database error');
                }
                
            }
        }
        
    }
         
    /**
     * Getting current user docs
     * @return array Array of Doc 
     */
    public function getDocs() {
        
        $fields = array('id', 'name', 'url', 'upload_date');
        
        $search = array( 'user_id' => $_SESSION['id'] );
        
        $this->_mapper->select($fields)->where($search);
        
        return $this->_mapper->fetch();
    }
    
}