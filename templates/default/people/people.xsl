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
    <xsl:import href="../common.xsl" />
    
    <xsl:output
        method="xml"
        omit-xml-declaration="yes"
        doctype-system="about:legacy-compat"
        encoding="UTF-8"
        indent="yes" />

    <!-- Include base template -->
    <xsl:include href="../default.xsl" />
    
    <!-- Title tag -->
    
    <xsl:template mode="title" match="/">
        <xsl:text>Люди</xsl:text>
    </xsl:template>
  
    <!-- Container template  -->
       
    <xsl:template match="dataset">
        <div class="span9">
            <div class="page-header">
                <h1>Люди</h1>
            </div>
                       
            <xsl:apply-templates select="Person" />
            
        </div>
        <div class="span3">
           <xsl:comment/>
        </div>
    </xsl:template>
    
    <!-- Scripts -->
    
    <xsl:template mode="scripts" match="/">
        <script>
            (function($){

            })(jQuery);
        </script>
    </xsl:template>
    
    <!-- 
        Person templates starts here 
    -->

    <xsl:template match="Person">
        <div class="row">
            <div class="span1">
                <a href="/people/{login}" class="thumbnail">
                    <xsl:apply-templates select="." mode="profile-picture-50" />
                </a>
            </div>
            <div class="span8">
                <p>
                    <a href="/people/{login}">
                        <xsl:apply-templates select="." mode="full-name" />
                    </a>
                </p>
                <xsl:apply-templates select="location" />
            </div>
        </div>
        
        <!-- Add horizontal line if not last -->
        <xsl:if test="position() != last()">
            <hr/>
        </xsl:if>
        
    </xsl:template>

    <!-- Current location template -->
    
    <xsl:template match="location">
        <p>
            <xsl:apply-templates />
        </p>
    </xsl:template>    
       
</xsl:stylesheet>
