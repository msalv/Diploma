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
        
    
    <!-- Blog posts  -->
       
    <xsl:template match="Blog">
        
        <xsl:apply-templates select="." mode="posts" />
        
    </xsl:template>
       
    <!-- 
        Posts template
    -->
    
    <xsl:template mode="posts" match="Blog[not(posts)]">
        <div class="alert alert-info">
            <xsl:apply-templates select="." mode="posts-info" />
        </div>
    </xsl:template>
    
    <xsl:template mode="posts-info" match="Blog[@locked = 0]">
        Здесь ещё никто ничего не написал
    </xsl:template>
    
    <xsl:template mode="posts-info" match="Blog[@locked = 1]">
        <b>Внимание!</b>
        <xsl:text> </xsl:text>
        <xsl:text>Записи группы доступны только подписчикам</xsl:text>
    </xsl:template>
    
    <xsl:template mode="posts" match="Blog">
        <xsl:apply-templates select="posts" />
    </xsl:template>
    
    <xsl:template match="posts">
        <xsl:apply-templates select="Post" />
    </xsl:template>
    
    <xsl:template match="Post">
        <div class="row">
            <div class="span8">
                <h3>
                    <a href="/groups/{@blog_id}/post/{@id}">
                        <xsl:value-of select="title" />
                    </a>
                </h3>
                <!--<p>-->
                    <xsl:value-of select="content" disable-output-escaping="yes" />
                <!--</p>-->
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
            </div>
        </div>

        <!-- Add horizontal line if not last -->
        <xsl:if test="position() != last()">
            <hr/>
        </xsl:if>
        
    </xsl:template>
         
</xsl:stylesheet>
