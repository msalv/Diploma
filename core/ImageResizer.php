<?php

/**
 * Description of ImageResizer
 *
 * @author Kirill
 */
class ImageResizer {
    
    private $_image;
    private $_width;
    private $_height;
    private $_type;
    
    public function __construct($path) {
        $size = getimagesize($path);
        if ( !$size ) {
            throw new Exception('Not an image');
        }
        
        list($this->_width, $this->_height, $this->_type) = $size;
        
        switch($this->_type) {
            case IMAGETYPE_GIF:
                $this->_image = imagecreatefromgif($path);
                break;
            case IMAGETYPE_JPEG:
                $this->_image = imagecreatefromjpeg($path);
                break;
            case IMAGETYPE_PNG:
                $this->_image = imagecreatefrompng($path);
                break;
            default:
                throw new Exception('Wrong image type');
        }
    }
    
    /**
     * Resize image to specified width and height. 
     * If height not set then makes it proportional.
     * @param integer $width Width of destination image
     * @param integer $height Height of destination image
     * @return boolean True on success or False on failure
     */
    public function resize($width, $height = null) {
        if ($this->_width <= $width) {
            return false;
        }
        
        if ( is_null($height) ) {
            $height = round( ($this->_height * $width) / $this->_width );
        }
        
        $temp = imagecreatetruecolor($width, $height);
        $res = imagecopyresampled($temp, $this->_image, 0, 0, 0, 0, $width, $height, $this->_width, $this->_height);
        
        if ($res) {
            $this->_image = $temp;
            $this->_width = $width;
            $this->_height = $height;

            return true;
        }
        else {
            return false;
        }
    }
    
    /**
     * Crops an image. If no parameters are set then crops to the square image
     * @param integer $x X coord of source image
     * @param integer $y Y coord of source image
     * @param integer $width Width of destination image
     * @param integer $height Height of destination image
     * @return boolean True on success or False on failure
     */
    public function crop($x = 0, $y = 0, $width = null, $height = null) {
        if ( is_null($width) ) {
            $width = $this->_width;
        }
        
        if ( is_null($height) ) {
            $height = $this->_width;
        }
        
        $temp = imagecreatetruecolor($width, $height);
        $res = imagecopy($temp, $this->_image, 0, 0, $x, $y, $width, $height);
        
        if ($res) {
            $this->_image = $temp;
            $this->_width = $width;
            $this->_height = $height;
            
            return true;
        }
        else {
            return false;
        }
    }
    
    /**
     * Saves image as JPEG with the specified filename in $path parameter
     * @param string $filename Path to file
     * @return bool True on success or False on failure
     */
    public function save($filename) {

        if ( !file_exists( dirname($filename) ) ) {
            mkdir( dirname($filename), 0755, true);
        }
        
        return imagejpeg($this->_image, $filename, 85);
    }
    
}
