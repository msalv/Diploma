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
        
        $this->clear();
        
        return $STH->fetchAll();
    }
    
    public function update() {
        
        $sql = "UPDATE people" . $this->_set . $this->_where;
        
        $STH = $this->_DBH->prepare($sql);
        
        $STH->execute($this->_params);
        
        $this->clear();
    }
    
    public function delete($modelObject) {
        
    }
    
    public function updateLastLogin($login) {
        $STH = $this->_DBH
                ->prepare("UPDATE people SET last_login=CURRENT_TIMESTAMP WHERE login=:login");
        
        $STH->execute( array('login' => $login) );
    }
}

