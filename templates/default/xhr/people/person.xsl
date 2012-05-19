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
       
    <xsl:template match="/">
            
        <xsl:apply-templates select="Person" mode="user-info" />
            
    </xsl:template>
    
    <!-- 
        User Info templates
    -->
    
    <xsl:template mode="user-info" match="Person[@privacy_info = '1']">
        <hr />
        <div class="alert">
            <xsl:value-of select="first_name" />
            <xsl:if test="@gender = '1'">
                <xsl:text> предпочёл </xsl:text>
            </xsl:if>
            <xsl:if test="@gender = '0'">
                <xsl:text> предпочла </xsl:text>
            </xsl:if>
            <xsl:text>не рассказывать о себе всем подряд</xsl:text>
        </div>
    </xsl:template>
    
    <xsl:template mode="user-info" match="Person">
        <xsl:apply-templates select="date_of_birth" />
        <xsl:apply-templates select="location" />
        <xsl:apply-templates select="hometown" />
        <xsl:apply-templates select="work_phone" />
        <xsl:apply-templates select="home_phone" />
        <xsl:apply-templates select="info" />
    </xsl:template>
    
    <!-- Birthday template -->
    
    <xsl:template match="date_of_birth">
        <hr />
        <div class="row">
            <div class="span2">
                <xsl:text>День рождения</xsl:text>
            </div>
            <div class="span7">
                <xsl:value-of select="number(@day)" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="document('../../calendar.xml')/months/item[position() = number(current()/@month)]/text()"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="@year" />
                <xsl:text> г.</xsl:text>
            </div>
        </div>
    </xsl:template>

    <!-- Templates below calls row template -->
           
    <xsl:template match="location">
        <xsl:call-template name="row">
            <xsl:with-param name="title" select="'Местоположение'" />
        </xsl:call-template>
    </xsl:template>
        
     <xsl:template match="hometown">
        <xsl:call-template name="row">
            <xsl:with-param name="title" select="'Родной город'" />
        </xsl:call-template>
    </xsl:template>
    
     <xsl:template match="work_phone">
        <xsl:call-template name="row">
            <xsl:with-param name="title" select="'Рабочий телефон'" />
        </xsl:call-template>
    </xsl:template>
    
     <xsl:template match="home_phone">
        <xsl:call-template name="row">
            <xsl:with-param name="title" select="'Домашний телефон'" />
        </xsl:call-template>
    </xsl:template>
    
     <xsl:template match="info">
        <xsl:call-template name="row">
            <xsl:with-param name="title" select="'О себе'" />
        </xsl:call-template>
    </xsl:template>
    
    <!-- Row template -->
    
    <xsl:template name="row">
        <xsl:param name="title" />
        <xsl:if test="string(.)">
            <hr />
            <div class="row">
                <div class="span2">
                    <xsl:value-of select="$title" />
                </div>
                <div class="span7">
                    <xsl:value-of select="." />
                </div>
            </div>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
