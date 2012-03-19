<?php

/**
 * ViewLoader supposed to load some data to the views
 *
 * @author Kirill
 */
interface ViewLoader {
    
    public function prepare($dataset);
    public function load($data);
}
