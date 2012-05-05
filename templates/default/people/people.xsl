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
    
    <!-- Title tag -->
    
    <xsl:template mode="title" match="/">
        <xsl:text>Люди</xsl:text>
    </xsl:template>
  
    <!-- Container template  -->
       
    <xsl:template match="dataset">
        <div class="span3">
           Left sidebar
        </div>
        <div class="span9">
            <div class="page-header">
                <h1>Люди</h1>
            </div>
                       
            <xsl:apply-templates select="Person" />
            
        </div>
    </xsl:template>

    <!-- 
        Person templates starts here 
    -->

    <xsl:template match="Person">
        <div class="row">
            <div class="span1">
                <a href="/people/{login}" class="thumbnail">
                    <xsl:apply-templates select="." mode="profile-picture" />
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
        <xsl:apply-templates select="." mode="add-separator" />
    </xsl:template>

    <!-- Add horizontal line after every odd person -->
    
    <xsl:template mode="add-separator" match="Person" >
        <hr />
    </xsl:template>
    
    <!-- Otherwise do nothing -->
    
    <xsl:template mode="add-separator" match="Person[position() mod 2 = 0]" />

    <!-- Current location template -->
    
    <xsl:template match="location">
        <p>
            <xsl:apply-templates />
        </p>
    </xsl:template>    
    
    <!--
        Person's full name templates
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
        <img src="/media/img/female_50.png" class="profile-small" />
    </xsl:template>
    
    <!-- Male default picture -->
    
    <xsl:template mode="gender-picture" match="Person">
        <img src="/media/img/male_50.png" class="profile-small" />
    </xsl:template>
    
    <!-- Profile picture is set -->
    
    <xsl:template mode="profile-picture" match="Person">
        <img src="/media/thumbs/{picture_url}/{@id}.jpg" class="profile-small" />
    </xsl:template>

</xsl:stylesheet>
