<?php

/**
 * Parent class for all controllers in the project. 
 * @author Kirill
 */
abstract class Controller {
    protected $_mapper;
    protected $_view;
    
    /**
     * Checks if $_POST variable contains all required data. 
     * If data not set the function sets them to empty string. 
     */
    protected function _checkPostData() {
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
    
    public function loadView($modelData = null, $rootName = null, $makeSet = false) {
        if ( !empty($modelData) ) {
            $modelData = $this->_view->prepare($modelData, $makeSet);
        }
        
        //header('Content-type: text/xml');
        //echo $modelData->saveXML();
        //exit();
              
        $this->_view->load($modelData, $rootName);
    }
}
