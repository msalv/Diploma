<?php

require_once PROJECT_ROOT . '/core/Mapper.php';
require_once UPLOADS_ROOT . '/Doc.php';

/**
 * Description of BlogMapper
 *
 * @author Kirill
 */
class DocMapper extends Mapper {
    
    public function save($data) {
        
        $sql = "INSERT INTO docs (user_id, url, name) VALUES (:user_id, :url, :name)";
        
        $STH = $this->_DBH->prepare($sql);
        
        $STH->execute($data);
    }
    
    public function fetch() {
              
        $sql = "SELECT $this->_select FROM docs"
                . $this->_where
                . $this->_order
                . $this->_limit;
              
        // Prepare and execute statement fetching to Doc class
        $STH = $this->_DBH->prepare($sql);
        $STH->setFetchMode(PDO::FETCH_CLASS, 'Doc');
        
        $STH->execute($this->_params);
        
        $this->clear();
        
        return $STH->fetchAll();
    }
    
    public function update() {
        
        $sql = "UPDATE docs" . $this->_set . $this->_where;
        
        $STH = $this->_DBH->prepare($sql);
        
        $STH->execute($this->_params);
        
        $this->clear();
    }
    
    public function delete($modelObject) {
        // TODO: deletion
    }

}
