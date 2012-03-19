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
    protected $_select = "*";
    protected $_where = "";
    protected $_limit = "";
    protected $_order = "";
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
    public abstract function fetch();
    public abstract function update($modelObject);
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
        $this->_params = $search;
            
        return $this;
    }
    
    public function limit($start, $duration) {
        
        if ( is_numeric($start) && is_numeric($duration) ) {
            
            $start = (int)$start;
            $duration = (int)$duration;
            
            $this->_limit = " LIMIT $start, $duration";
        }
        return $this;
    }
    
    public function orderBy() {
        $this->_order = " ORDER BY " . implode(', ', func_get_args() );
        return $this;
    }
}

?>
