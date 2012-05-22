<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : person.xsl
    Created on : March 16, 2012, 8:54 PM
    Author     : Кирилл
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
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
        Лента новостей
    </xsl:template>
  
    <!-- Person information  -->
       
    <xsl:template match="dataset">
        <div class="span9">
            <div class="page-header">
                <h1>
                    Лента новостей
                </h1>
            </div>
            
            <!--
            <xsl:call-template name="wall-form">
                <xsl:with-param name="wall_id" select="$id" />
                <xsl:with-param name="locked" select="0" />
            </xsl:call-template>
            -->
            
            <div id="posts">
                <xsl:apply-templates select="meta" />
                <xsl:apply-templates select="." mode="posts" />
            </div>
        </div>
        
        <div class="span3">
            <h4 style="margin: 0 0 9px;">
                Ближайшие мероприятия
            </h4>
            
            <div id="sidebar-events"><xsl:text><![CDATA[]]></xsl:text></div>
        </div>
        
    </xsl:template>
    
    <xsl:template mode="scripts" match="/">
        <script src="/media/js/modules/people.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>
        
        <script>
            <xsl:text disable-output-escaping="yes">
            (function($) {
                $('div#sidebar-events').load('/feed?events&amp;mode=feed');
            })(jQuery);
            </xsl:text>
        </script>
        
    </xsl:template>
            
    <!-- 
        Posts template
    -->
       
    <xsl:template mode="posts" match="dataset">
        <xsl:apply-templates select="Post" />
        <xsl:if test="not(string(.))">
            <div class="alert alert-info">
                <h4 class="alert-heading">В Багдаде всё спокойно</h4>
                Сейчас ваша лента пуста. Чтобы наполнить её, найдите друзей.
            </div>
        </xsl:if>
    </xsl:template>
       
    <xsl:template match="Post">
        <div class="row">
            <div class="span1">
                <a href="/people/{author_login}" class="thumbnail">
                    <xsl:apply-templates select="." mode="profile-picture-50"/>
                </a>
            </div>
            <div class="span8">
                <xsl:apply-templates select="." mode="post-type" />
            </div>
        </div>

        <!-- Add horizontal line if not last -->
        <xsl:if test="position() != last()">
            <hr/>
        </xsl:if>
        
    </xsl:template>
    
    <!-- Personal post -->
    
    <xsl:template mode="post-type" match="Post[not(title)]">
        <h4 style="margin: 0 0 9px;">
            <a href="/people/{author_login}/wall/post/{@id}">
                <xsl:value-of select="author_name" />
            </a>
        </h4>
        
        <xsl:value-of select="content" disable-output-escaping="yes" />
        
        <p>
            <small>
                <xsl:apply-templates select="pub_date" />
                <xsl:text> | </xsl:text>
                    <a href="/people/{author_login}/wall/post/{@id}#comments">
                        <xsl:apply-templates select="." mode="comments" />
                    </a>
            </small>
        </p>
    </xsl:template>
    
    <!-- Blog post -->
    
    <xsl:template mode="post-type" match="Post">
        <h4 style="margin: 0 0 9px;">
            <a href="/groups/{@blog_id}/post/{@id}">
                <xsl:value-of select="blog_title" />
            </a>
            <xsl:text>. </xsl:text>
            <xsl:value-of select="title" />
        </h4>
        
        <xsl:value-of select="content" disable-output-escaping="yes" />
        
        <p>
            <small>
                <a href="/people/{author_login}">
                    <xsl:value-of select="author_name" />
                </a>
                <xsl:text> | </xsl:text>
                <xsl:apply-templates select="pub_date" />
                <xsl:text> | </xsl:text>
                    <a href="/groups/{@blog_id}/post/{@id}#comments">
                        <xsl:apply-templates select="." mode="comments" />
                    </a>
            </small>
        </p>
    </xsl:template>
             
</xsl:stylesheet>
