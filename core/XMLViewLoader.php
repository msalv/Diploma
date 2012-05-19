<?php

/**
 * XMLViewLoader converts model objects to XML 
 * then loads it to the XSL view using XLST or not if request is XHR
 *
 * @author Kirill
 */
class XMLViewLoader {
    
    private $_template;
    
    public function __construct($template) {
        $this->_template = $template;
    }
    
    /**
     * Checks whether request is XMLHttpRequest or not
     * @return boolean True on success or False on fail
     */
    private function _isXHR(){
        return isset($_SERVER['HTTP_X_REQUESTED_WITH']);
    }
    
    /**
     * Converts model objects to DOMDocument
     * @param array $dataset Array of model objects
     * @param boolean $makeSet If true makes set even when there is only one item in $dataset
     * @return DOMDocument Resulting XML
     */
    public function prepare($dataset, $makeSet = false) {
        
        $dom = new DOMDocument('1.0', 'utf-8');
        
        if ( $makeSet || count($dataset) > 1 ) {
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
    
    /**
     * Loads view. In other words, outputs transformed or not XML
     * @param DOMDocument $data XML with data that needs to be associated with view
     * @param string $rootName Name for the XML root element. Used only when $data is empty.
     */
    public function load($data = null, $rootName = null) {
        
        if ( empty($data) ) {
            $data = new DOMDocument('1.0', 'utf-8');
            $rootName = ( $rootName ) ?: 'dataset';
            $data->appendChild( new DOMElement($rootName) );
        }
        
        // if requested via AJAX, use xhr templates
        if ( $this->_isXHR() ) {
            $this->_template = 'xhr/' . $this->_template;
            
            // check for mode flag
            if ( isset( $_GET['mode'] ) ) {
                $data->documentElement->setAttribute('mode', $_GET['mode']);
            }
        }
                             
        // transform with XSL
        $xsl = new DOMDocument();
        $xsl->load(TEMPLATE_ROOT . $this->_template);
        
        $proc = new XSLTProcessor();
        $proc->importStylesheet($xsl);
        
        if ( !empty($_SESSION) ) {
            $proc->setParameter('', array_merge($_COOKIE, $_SESSION) );
        }
        
        echo $proc->transformToXml($data);
    }
    
}
