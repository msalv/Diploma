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
     
    <!-- Person information  -->
       
    <xsl:template match="Person">
                       
        <xsl:apply-templates select="." mode="friends-list" />
            
    </xsl:template>
             
    <!-- 
        Friends templates
    -->
    
    <xsl:template mode="friends-list" match="Person[@privacy_friends = '1']">
        <hr />
        <div class="alert">
            <xsl:value-of select="first_name" />
            <xsl:text> прячет своих друзей от чужих глаз.</xsl:text>
        </div>
    </xsl:template>
    
    <xsl:template mode="friends-list" match="Person[not(friends)]">
        <hr />
        <div class="alert">
            <xsl:text>Друзья не обнаружены</xsl:text>
        </div>
    </xsl:template>
    
    <!-- Block mode -->
    
    <xsl:template mode="friends-list" match="Person[@mode = 'block' and @privacy_friends = '0']">
        <xsl:apply-templates select="friends" mode="block" />
        <xsl:if test="not(friends)">
            <hr />
            <div class="alert">
                <xsl:text>Друзья не обнаружены</xsl:text>
            </div>
        </xsl:if>
    </xsl:template>
    
    <!-- Normal mode -->
    
    <xsl:template mode="friends-list" match="Person">
        <xsl:apply-templates select="friends" />
    </xsl:template>
    
    <xsl:template match="friends">
        <xsl:apply-templates select="Person" mode="friend" />
    </xsl:template>
    
    <xsl:template match="friends" mode="block">
        <hr/>
        <h3>
            <a href="/people/{/Person/login}/friends">Друзья</a>
        </h3>
        <p><xsl:text><![CDATA[]]></xsl:text></p>
        
        <ul class="thumbnails">
            <xsl:apply-templates select="Person" mode="thumb" />
        </ul>
    </xsl:template>
          
    <!-- 
        Friend templates starts here 
    -->

    <xsl:template mode="friend" match="Person">
        <hr />
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
    </xsl:template>
    
</xsl:stylesheet>
