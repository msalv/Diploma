<?php

/**
 * Parent class for all data mappers in the project.
 * It provides default operations on the models.
 *
 * @author Kirill
 */
abstract class Mapper {
    public abstract function save($modelObject);
    public abstract function find($options);
    public abstract function update($modelObject);
    public abstract function delete($modelObject);
}

?>
