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

    <!-- Terrible including goes here -->
    <xsl:include href="../../../templates/default.xsl" />
    
    <xsl:template mode="title" match="Person">
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
        <xsl:apply-templates select="hometown" />
        <xsl:apply-templates select="work_phone" />
        <xsl:apply-templates select="home_phone" />
        <xsl:apply-templates select="info" />
    </xsl:template>
    
    <xsl:template match="date_of_birth">
        <hr />
        <div class="row">
            <div class="span2">
                День рождения
            </div>
            <div class="span7">
                <xsl:apply-templates />
            </div>
        </div>
    </xsl:template>
        
     <xsl:template match="hometown">
        <hr />
        <div class="row">
            <div class="span2">
                Родной город
            </div>
            <div class="span7">
                <xsl:apply-templates />
            </div>
        </div>
    </xsl:template>
    
     <xsl:template match="work_phone">
        <hr />
        <div class="row">
            <div class="span2">
                Рабочий телефон
            </div>
            <div class="span7">
                <xsl:apply-templates />
            </div>
        </div>
    </xsl:template>
    
     <xsl:template match="home_phone">
        <hr />
        <div class="row">
            <div class="span2">
                Домашний телефон
            </div>
            <div class="span7">
                <xsl:apply-templates />
            </div>
        </div>
    </xsl:template>
    
     <xsl:template match="info">
        <hr />
        <div class="row">
            <div class="span2">
                О себе
            </div>
            <div class="span7">
                <xsl:apply-templates />
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>
