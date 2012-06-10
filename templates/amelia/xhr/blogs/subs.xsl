<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : person.xsl
    Created on : March 16, 2012, 8:54 PM
    Author     : Кирилл
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   
    <!-- Import common templates -->
    <xsl:import href="../../common.xsl" />
   
    <xsl:output
        method="xml"
        omit-xml-declaration="yes"
        encoding="UTF-8"
        indent="yes" />
        
    <xsl:template match="dataset" mode="output">
        
        <xsl:if test="string(.)">
            <ul class="thumbnails">
                <xsl:apply-templates select="Person" mode="block" />
            </ul>
        </xsl:if>
        
        <xsl:if test="not(string(.))">
            <div class="alert">Эта группа пуста</div>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="dataset[@mode = 'block']">
                       
        <xsl:apply-templates select="." mode="output"/>
            
    </xsl:template>
       
    <xsl:template match="dataset[@mode = 'modal']">

        <div class="modal-header">
            <button data-dismiss="modal" class="close">×</button>
            <h3>Подписчики</h3>
        </div>
        <div class="modal-body">
                       
            <xsl:apply-templates select="." mode="output"/>
        
        </div>
        
        <div class="modal-footer">
            <a class="btn" href="#" data-dismiss="modal">Закрыть</a>
        </div>
            
    </xsl:template>
    
    <!-- Block -->
       
    <xsl:template match="Person" mode="block">
               
        <xsl:apply-templates select="." mode="thumb" />
        
    </xsl:template>
              
</xsl:stylesheet>
