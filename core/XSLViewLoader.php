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
        $this->_template = TEMPLATE_ROOT . $template;
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
    
    public function load($data = null, $rootName = null) {
        
        if ( is_null($data) ) {
            $data = new DOMDocument('1.0', 'utf-8');
            $rootName = ( $rootName ) ?: 'root';
            $data->appendChild( new DOMElement($rootName) );
        }
        
        $xsl = new DOMDocument();
        $xsl->load($this->_template);
        
        $proc = new XSLTProcessor();
        $proc->importStylesheet($xsl);
        
        if ( !empty($_SESSION) ) {
            $proc->setParameter('', array_merge($_COOKIE, $_SESSION) );
        }
        
        echo $proc->transformToXml($data);
    }
    
}
