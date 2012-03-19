<?php

require_once PROJECT_ROOT . '/core/ViewLoader.php';

/**
 * XSLViewLoader converts model objects to XML 
 * then loads it to the XSL view using XLST
 *
 * @author Kirill
 */
class XSLViewLoader implements ViewLoader {
    
    private $_template;
    
    public function __construct($template) {
        $this->_template = MODULE_ROOT . '/views/'. $template;
    }
    
    public function prepare($dataset) {
        
        $dom = new DOMDocument('1.0', 'utf-8');
        
        if ( count($dataset) > 1 ) {
            $root = new DOMElement('dataset');
            $dom->appendChild($root);
            
            foreach ($dataset as $record) {
                $record->toDOMElement($root);
            }
        }
        else {
            $dataset[0]->toDOMElement($dom);
        }
        
        return $dom;
    }
    
    public function load($data) {
        
        $xsl = new DOMDocument();
        $xsl->load($this->_template);
        
        $proc = new XSLTProcessor();
        $proc->importStylesheet($xsl);
        
        echo $proc->transformToXml($data);
    }
    
}
