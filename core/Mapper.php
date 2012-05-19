<?php

/**
 * Parent class for all data mappers in the project.
 * It provides default operations on the models.
 *
 * @author Kirill
 */
abstract class Mapper {
    
    /**
     * @property DBO $_DBH Instance of DBO class
     */
    protected $_DBH;
    protected $_select = '*';
    protected $_where = '';
    protected $_set = '';
    protected $_limit = '';
    protected $_order = '';
    protected $_params = array();
    
    public function __construct() {
        
        try {
            $this->_DBH = new PDO(CONN_STRING, DB_USER, DB_PASS);
            
            $this->_DBH->setAttribute(PDO::ATTR_ERRMODE, PDO_ERRMODE);
        }
        catch (PDOException $e) {
            echo "<pre>" . $e->getMessage() . "</pre>"; // just for now
        }
    }
    
    public function __destruct() {
        $this->_DBH = null;
    }

    public abstract function save($modelObject);
    public abstract function update();
    public abstract function fetch();
    public abstract function delete($modelObject);
    
    public function select($fields) {
        
        $fields = ( !is_array($fields) ) ? func_get_args() : $fields;
        
        $this->_select = implode(', ',  $fields);
        
        return $this;
    }
    
    public function where($search) {
        
        $where = array_map(
            function ($key) {
                return $key .= "=:$key";
            }, 
            array_keys($search)
        );
            
        $this->_where = " WHERE " . implode(' AND ', $where);
        $this->_params = array_merge($this->_params, $search);
            
        return $this;
    }
    
    public function set($data) {
        
        if ( isset($data['@attributes']) ) {
            $data = array_merge($data, $data['@attributes']);
        }
        
        unset( $data['@attributes'] );
        unset( $data['meta'] );
               
        $update = array_map(
            function ($key) {
                return $key .= "=:$key";
            },
            array_keys($data)
        );
            
        $this->_set = " SET " . implode(', ', $update);
        $this->_params = array_merge($this->_params, $data);
            
        return $this;
    }
    
    public function limit($start, $duration) {
        
        if ( is_numeric($start) && is_numeric($duration) ) {
            
            $start = intval($start);
            $duration = intval($duration);
        }
        else {
            $start = 0;
            $duration = 10;
        }
        $this->_limit = " LIMIT $start, $duration";
        
        return $this;
    }
    
    public function orderBy() {
        $this->_order = " ORDER BY " . implode(', ', func_get_args() );
        return $this;
    }
    
    public function clear() {
        $this->_select = '*';
        $this->_where = '';
        $this->_set = '';
        $this->_limit = '';
        $this->_order = '';
        $this->_params = array();
    }
}
