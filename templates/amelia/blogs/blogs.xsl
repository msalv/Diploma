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
        <xsl:text>Группы</xsl:text>
    </xsl:template>
  
    <!-- Container template  -->
       
    <xsl:template match="dataset">
        <div class="span9">
            <div class="page-header">
                <h1>Группы</h1>
            </div>
                       
            <xsl:apply-templates select="Blog" />
            
        </div>
        <div class="span3">
           <xsl:apply-templates select="." mode="create-button" />
        </div>
    </xsl:template>
    
    <!-- Scripts -->
    
    <xsl:template mode="scripts" match="/">
        <script>
            (function($){

            })(jQuery);
        </script>
    </xsl:template>
    
    <!-- Create new button -->
    
    <xsl:template mode="create-button" match="dataset">
    
        <div class="well">
            <p>Чтобы создать новую группу, нажмите на кнопку</p>
            <div style="text-align:right;">
                <a class="btn btn-info" href="/groups/new">
                    <i class="icon-asterisk icon-white"><xsl:text><![CDATA[]]></xsl:text></i>
                    <xsl:text> </xsl:text>
                    Создать
                </a>
            </div>
        </div>
            
    </xsl:template>
    
    <!-- 
       Blog templates starts here 
    -->

    <xsl:template match="Blog">
        <div class="row">
            <div class="span9">
                <h3>
                    <a href="/groups/{@id}">
                        <xsl:value-of select="title" />
                    </a>
                </h3>
                <xsl:apply-templates select="info" />
            </div>
        </div>
        
        <!-- Add horizontal line if not last -->
        <xsl:if test="position() != last()">
            <hr/>
        </xsl:if>
        
    </xsl:template>

    <!-- Blog info template -->
    
    <xsl:template match="info">
        <p>
            <xsl:apply-templates />
        </p>
    </xsl:template>    
       
</xsl:stylesheet>
