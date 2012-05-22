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
    
    <!-- Import forms -->
    <xsl:import href="../forms.xsl" />
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
    
    <xsl:template mode="title" match="/">
        <xsl:text>Сообщение</xsl:text>
    </xsl:template>
     
    <!-- Post  -->
       
    <xsl:template match="Post">

        <div class="span12">
            
            <div class="page-header">
                <h1>
                    <xsl:apply-templates select="." mode="title" />
                </h1>
            </div>
            
            <xsl:apply-templates select="." mode="content" />
            
            <hr/>
            
            <h3 style="margin:0 0 19px;">
                <xsl:apply-templates select="." mode="comments" />
            </h3>
            
            <div id="comments">
                <xsl:apply-templates select="." mode="comms" />
            </div>
            
            <!-- Comment form -->
                
            <form method="POST" action="/people/{author_login}/wall/post/{@id}" class="well span8" id="comm-posting">
                <textarea placeholder="Напишите комментарий..." style="width:98%;" rows="1" name="content" id="content">
                    <xsl:text><![CDATA[]]></xsl:text>
                </textarea>
                <button class="btn btn-info" type="submit">Отправить</button>
                <a class="btn" type="submit" href="/uploads" id="attach">Прикрепить</a>
            </form>
                       
        </div>
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
