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
        <xsl:apply-templates select="." mode="full-name" />
        <xsl:text> : группы</xsl:text>
    </xsl:template>
  
    <!-- Person information  -->
       
    <xsl:template match="Person">
        <div class="span3">
            <xsl:apply-templates select="." mode="profile-picture" />
            
            <xsl:if test="@id = $id">
                <div id="sidebar-requests"><xsl:text><![CDATA[]]></xsl:text></div>
            </xsl:if>
            
            <div id="sidebar-friends"><xsl:text><![CDATA[]]></xsl:text></div>
            
        </div>
        <div class="span9">
            <div class="page-header">
                
                <xsl:if test="@id != $id">
                    <xsl:apply-templates select="." mode="user-actions" />
                </xsl:if>
                
                <h1>
                    <xsl:apply-templates select="." mode="full-name" />
                </h1>
            </div>
            
            <div class="subnav">
                <ul class="nav nav-pills">
                    <li><a href="/people/{login}/wall" data-toggle="pill" data-target="#wall">Стена</a></li>
                    <li><a href="/people/{login}/profile" data-toggle="pill" data-target="#profile">Профиль</a></li>
                    
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                            Друзья <b class="caret"><xsl:text><![CDATA[]]></xsl:text></b>
                        </a>
                        <ul class="dropdown-menu">
                            <li>
                                <a href="/people/{login}/friends" data-toggle="pill" data-target="#friends">Все друзья</a>
                            </li>
                            <li>
                                <a href="/people/{login}/friends" data-toggle="pill" data-target="#online">Онлайн</a>
                            </li>

                            <xsl:if test="@id = $id">
                                <li class="divider"><xsl:text><![CDATA[]]></xsl:text></li>
                                <li><a href="/people/friends/requests" data-toggle="pill" data-target="#requests">Заявки</a></li>
                            </xsl:if>
                        </ul>
                    </li>
                    
                    <li class="active">
                        <a href="/people/{login}/groups" data-toggle="pill" data-target="#groups">Группы</a>
                    </li>
                </ul>
            </div>
            
            <div class="pill-content">
                <div class="pill-pane fade" id="wall">
                                      
                    <xsl:call-template name="wall-form">
                        <xsl:with-param name="login" select="login" />
                        <xsl:with-param name="locked" select="current()/@privacy_wall" />
                    </xsl:call-template>
                    
                    <div id="posts">
                        <xsl:text><![CDATA[]]></xsl:text>
                    </div>
                </div>
                <div class="pill-pane fade" id="profile"><xsl:text><![CDATA[]]></xsl:text></div>
                <div class="pill-pane fade" id="friends"><xsl:text><![CDATA[]]></xsl:text></div>
                <div class="pill-pane fade" id="online"><xsl:text><![CDATA[]]></xsl:text></div>
                <div class="pill-pane fade" id="requests"><xsl:text><![CDATA[]]></xsl:text></div>
                <div class="pill-pane fade in active" id="groups">
                    <xsl:apply-templates select="." mode="blogs-list" />
                </div>
            </div>
            
        </div>
    </xsl:template>
    
    <!-- scripts -->
    
    <xsl:template mode="scripts" match="/">
        <script src="/media/js/modules/people.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>
        
        <xsl:call-template name="user-sidebar">
            <xsl:with-param select="Person/login" name="login"/>
        </xsl:call-template>
        
    </xsl:template>
          
    <!-- 
        Friends templates
    -->
    
    <xsl:template mode="blogs-list" match="Person[@privacy_groups = '1']">
        <hr />
        <div class="alert">
            <xsl:value-of select="first_name" />
            <xsl:text> не разглашает список своих групп</xsl:text>
        </div>
    </xsl:template>
    
    <xsl:template mode="blogs-list" match="Person[not(blogs)]">
        <hr />
        <div class="alert">
            <xsl:text>Ни одной группы не найдено</xsl:text>
        </div>
    </xsl:template>
    
    <xsl:template mode="blogs-list" match="Person">
        <xsl:apply-templates select="blogs" />
    </xsl:template>
    
    <xsl:template match="blogs">
        <xsl:apply-templates select="Blog" />
    </xsl:template>
          
    <!-- 
        Blog templates starts here 
    -->

    <xsl:template match="Blog">
        <hr />
        <div class="row">
            <div class="span9">
                <h3>
                    <a href="/groups/{@id}">
                        <xsl:value-of select="title" />
                    </a>
                </h3>
                <xsl:apply-templates select="info" />
            </div>
        </div>
    </xsl:template>
    
    <!-- Blog info template -->
    
    <xsl:template match="info">
        <p>
            <xsl:apply-templates />
        </p>
    </xsl:template>  

</xsl:stylesheet>
