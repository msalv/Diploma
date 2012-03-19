<?php

require_once PROJECT_ROOT . '/core/Mapper.php';

/**
 * PersonMapper is an abstract layer between DB and Person objects
 *
 * @author Kirill
 */
class PersonMapper extends Mapper {

    public function save($modelObject) {
        
    }
    
    public function fetch() {
              
        $sql = "SELECT $this->_select FROM people"
                . $this->_where
                . $this->_order
                . $this->_limit;
              
        // Prepare and execute statement fetching to Person class
        $STH = $this->_DBH->prepare($sql);
        $STH->setFetchMode(PDO::FETCH_CLASS, 'Person');
        
        $STH->execute($this->_params);
        
        return $STH->fetchAll();
    }
    
    public function update($modelObject) {
        
    }
    
    public function delete($modelObject) {
        
    }
}

