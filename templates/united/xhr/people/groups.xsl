<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : person.xsl
    Created on : March 16, 2012, 8:54 PM
    Author     : Кирилл
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:output
        method="xml"
        omit-xml-declaration="yes"
        encoding="UTF-8"
        indent="yes" />

    <!-- Person information  -->
       
    <xsl:template match="Person">

        <xsl:apply-templates select="." mode="blogs-list" />

    </xsl:template>
             
    <!-- 
        Blogs templates
    -->
    
    <xsl:template mode="blogs-list" match="Person[@privacy_groups = '1']">
        <hr />
        <div class="alert">
            <xsl:value-of select="first_name" />
            <xsl:text> не разглашает список своих групп</xsl:text>
        </div>
    </xsl:template>
    
    <xsl:template mode="blogs-list" match="Person[not(blogs)]">
        <hr />
        <div class="alert">
            <xsl:text>Список групп пуст</xsl:text>
        </div>
    </xsl:template>
    
    <!-- Block mode -->
    
    <xsl:template mode="blogs-list" match="Person[@mode = 'block']">
        <xsl:apply-templates select="blogs" mode="block" />
        <xsl:if test="not(blogs)">
            <hr />
            <div class="alert">
                <xsl:text>Список групп пуст</xsl:text>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template mode="blogs-list" match="Person">
        <xsl:apply-templates select="blogs" />
    </xsl:template>
    
    <xsl:template match="blogs">
        <xsl:apply-templates select="Blog" />
    </xsl:template>
    
    <xsl:template match="blogs" mode="block">
        <hr/>
        <h3>
            <a href="/people/{/Person/login}/groups">Группы</a>
        </h3>
        <p>
            <xsl:apply-templates select="Blog" mode="block" />
        </p>
    </xsl:template>
    
    <xsl:template match="Blog" mode="block">
        
        <a href="/groups/{@id}">
            <xsl:value-of select="title" />
        </a>
        <xsl:if test="position() != last()">
            <xsl:text> · </xsl:text>
        </xsl:if>
        
    </xsl:template>
          
    <!-- 
        Blog templates starts here 
    -->

    <xsl:template match="Blog">
        <hr />
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
    </xsl:template>
    
    <!-- Blog info template -->
    
    <xsl:template match="info">
        <p>
            <xsl:apply-templates />
        </p>
    </xsl:template>  

</xsl:stylesheet>
