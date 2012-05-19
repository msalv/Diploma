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
        <xsl:value-of select="Blog/title" />
    </xsl:template>
  
    <!-- Person information  -->
       
    <xsl:template match="Blog">
        <div class="span9">
            <div class="page-header">
                <xsl:if test="./owners/Person/@id = $id">
                    <xsl:apply-templates select="." mode="admin-actions" />
                </xsl:if>
                <h1>
                    <xsl:apply-templates select="title" />
                </h1>
            </div>
            
            <xsl:call-template name="blog-form">
                <xsl:with-param name="blog_id" select="@id" />
                <xsl:with-param name="locked" select="@locked" />
            </xsl:call-template>
            
            <div id="posts">
                <xsl:apply-templates select="meta" />
                <xsl:apply-templates select="." mode="posts" />
            </div>
        </div>
        
        <div class="span3">
            
            <xsl:apply-templates select="." mode="subscribe-button" />
            
            <hr />
            <h4>
                <a href="/groups/{@id}/subscribers" id="show-subs">Подписчики</a>
            </h4>
            <p><xsl:text><![CDATA[]]></xsl:text></p>
            <div id="sidebar-subs"><xsl:text><![CDATA[]]></xsl:text></div>
            
            <xsl:apply-templates select="owners" />
        </div>
    </xsl:template>
    
    <xsl:template mode="scripts" match="/">
        <script src="/media/js/modules/blogs.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>
        
        <xsl:call-template name="blog-sidebar">
            <xsl:with-param name="id" select="/Blog/@id"/>
        </xsl:call-template>
                
    </xsl:template>
    
    <xsl:template match="info">
        <p>
            <xsl:apply-templates />
        </p>
    </xsl:template>
    
    <!-- Admin actions -->
    
    <xsl:template mode="admin-actions" match="Blog">
        
        <div class="btn-group pull-right">

            <a class="btn dropdown-toggle" data-toggle="dropdown" href="#" rel="tooltip" title="Меню группы">
                <i class="icon-tasks">
                    <xsl:text><![CDATA[]]></xsl:text>    
                </i>
                <xsl:text> </xsl:text>
                <span class="caret">
                    <xsl:text><![CDATA[]]></xsl:text>
                </span>
            </a>

            <ul class="dropdown-menu">
                <li>
                    <a href="/groups/{@id}/admin/owners" id="mng-owners">
                        <i class="icon-user">
                            <xsl:text><![CDATA[]]></xsl:text>
                        </i>
                        <xsl:text> Руководство</xsl:text>
                    </a>
                </li>
                <li>
                    <a href="/groups/{@id}/admin/events" id="mng-events">
                        <i class="icon-time">
                            <xsl:text><![CDATA[]]></xsl:text>
                        </i>
                        <xsl:text> События</xsl:text>
                    </a>
                </li>
                <li class="divider">
                    <xsl:text><![CDATA[]]></xsl:text>    
                </li>
                <li>
                    <a href="/groups/{@id}/admin/settings" id="mng-settings">
                        <i class="icon-cog">
                            <xsl:text><![CDATA[]]></xsl:text>
                        </i>
                        <xsl:text> Настройки</xsl:text>
                    </a>
                </li>
            </ul>

        </div>
        
    </xsl:template>
    
    <!-- Unsubscribe button -->
    
    <xsl:template mode="subscribe-button" match="Blog[@subscribed = 1]">
    
        <form class="well" method="POST" action="/groups/{@id}">
            <xsl:apply-templates select="info" />
            <div style="text-align:right;">
                <button class="btn" type="submit">
                    <i class="icon-remove-sign"><xsl:text><![CDATA[]]></xsl:text></i>
                    <xsl:text> </xsl:text>
                    Отписаться
                </button>
                <input type="hidden" name="action" value="unsubscribe" />
            </div>
        </form>
            
    </xsl:template>
    
    <!-- Subscribe button -->
    
    <xsl:template mode="subscribe-button" match="Blog">
    
        <form class="well" method="POST" action="/groups/{@id}">
            <xsl:apply-templates select="info" />
            <div style="text-align:right;">
                <button class="btn btn-info" type="submit">
                    <i class="icon-plus-sign icon-white"><xsl:text><![CDATA[]]></xsl:text></i>
                    <xsl:text> </xsl:text>
                    Подписаться
                </button>
                <input type="hidden" name="action" value="subscribe" />
            </div>
        </form>
            
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
                    <a href="/groups/{/Blog/@id}/post/{@id}">
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
                            <a href="/groups/{/Blog/@id}/post/{@id}#comments">
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
    
    <!-- Owners -->
    
    <xsl:template match="owners">
        <hr />
        <h4>Руководство группы</h4>
        <p>
            <xsl:text><![CDATA[]]></xsl:text>
        </p>
            <ul class="thumbnails">
                <xsl:apply-templates select="Person" mode="thumb" />
            </ul>
    </xsl:template>
         
</xsl:stylesheet>
