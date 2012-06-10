<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : person.xsl
    Created on : March 16, 2012, 8:54 PM
    Author     : Кирилл
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl date">
    
    <!-- Import common templates -->
    <xsl:import href="../../common.xsl" />
    
    <xsl:output
        method="xml"
        omit-xml-declaration="yes"
        encoding="UTF-8"
        indent="yes" />
    
    <!-- Post  -->
       
    <xsl:template match="Post">
           
        <xsl:apply-templates select="." mode="comms" />

    </xsl:template>
    
    <!-- Scripts -->
    
    <xsl:template mode="scripts" match="/">
        <script src="/media/js/modules/blogs.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>
    </xsl:template>
    
    <!-- Title -->

    <xsl:template mode="title" match="Post[not(title)]">
        <xsl:text>Сообщение на стене</xsl:text>
    </xsl:template>
    
    <xsl:template mode="title" match="Post">
        <xsl:value-of select="title" />
    </xsl:template>
    
    <!-- Content -->
    <xsl:template mode="content" match="Post">
        <div class="row">
            <div class="span1">
                <a href="/people/{author_login}" class="thumbnail">
                    <xsl:apply-templates select="." mode="profile-picture-50"/>
                </a>
            </div>
            <div class="span11">
                <xsl:value-of select="content" disable-output-escaping="yes" />
        
                <p>
                    <small>
                        <xsl:apply-templates select="pub_date" />
                    </small>
                </p>
            </div>
        </div>
    </xsl:template>
    
    <!-- Comments -->
    
    <xsl:template mode="comms" match="Post[not(comments)]">
        <xsl:text><![CDATA[]]></xsl:text>
    </xsl:template>
    
    <xsl:template mode="comms" match="Post">
        
        <xsl:apply-templates select="comments" />
        
    </xsl:template>
    
    <xsl:template match="comments">
        
        <xsl:apply-templates select="Comment" />
        
    </xsl:template>
    
    <xsl:template match="Comment">
        
        <div class="row">
            <div class="span">
                <a href="/people/{author_login}" class="thumbnail">
                    <xsl:apply-templates select="." mode="profile-picture-25"/>
                </a>
            </div>
            <div class="span8">
                <p>
                    <a href="/people/{author_login}">
                        <xsl:value-of select="author_name" />
                    </a>
                </p>
                
                <xsl:value-of select="content" disable-output-escaping="yes" />
        
                <p>
                    <small>
                        <xsl:apply-templates select="pub_date" />
                    </small>
                </p>
            </div>
        </div>
        
    </xsl:template>
    
</xsl:stylesheet>
