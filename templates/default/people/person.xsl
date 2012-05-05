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
        doctype-system="about:legacy-compat"
        encoding="UTF-8"
        indent="yes" />

    <!-- Include base template -->
    <xsl:include href="../default.xsl" />
    
    <xsl:template mode="title" match="/">
        <xsl:apply-templates select="." mode="full-name" />
    </xsl:template>
  
    <!-- Person information  -->
       
    <xsl:template match="Person">
        <div class="span3">
            <xsl:apply-templates select="." mode="profile-picture" />
        </div>
        <div class="span9">
            <div class="page-header">
                <h1>
                    <xsl:apply-templates select="." mode="full-name" />
                </h1>
            </div>
            
            <div class="subnav">
                <ul class="nav nav-pills">
                    <li><a href="#wall">Стена</a></li>
                    <li class="active"><a href="#profile">Профиль</a></li>
                    <li><a href="#friends">Друзья</a></li>
                    <li><a href="#groups">Группы</a></li>
                </ul>
            </div>
            
            <xsl:apply-templates select="." mode="user-info" />
            
        </div>
    </xsl:template>
    
    <!--
        Full person name templates
    -->
    
    <!-- Middle name is not set -->
       
    <xsl:template mode="full-name" match="Person[not(middle_name)]">
        <xsl:value-of select="concat(first_name, ' ', last_name)"/>
    </xsl:template>
    
    <!-- Middle name is set -->
    
    <xsl:template mode="full-name" match="Person">
        <xsl:value-of select="concat(first_name, ' ', middle_name, ' ', last_name)"/>
    </xsl:template>
    
    <!-- 
        Profile picture templates 
    -->
    
    <!-- Profile picture is not set -->
    
    <xsl:template mode="profile-picture" match="Person[not(picture_url)]">
        <xsl:apply-templates select="." mode="gender-picture" />
    </xsl:template>
    
    <!-- Female default picture -->
    
    <xsl:template mode="gender-picture" match="Person[@gender='0']">
        <img src="/media/img/female.png" />
    </xsl:template>
    
    <!-- Male default picture -->
    
    <xsl:template mode="gender-picture" match="Person">
        <img src="/media/img/male.png" />
    </xsl:template>
    
    <!-- Profile picture is set -->
    
    <xsl:template mode="profile-picture" match="Person">
        <img src="/media/userpics/{picture_url}/{@id}.jpg" />
    </xsl:template>
    
    <!-- 
        User Info templates
    -->
    
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
                <xsl:value-of select="@day" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="document('../calendar.xml')/months/item[position() = number(current()/@month)]/text()"/>
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
