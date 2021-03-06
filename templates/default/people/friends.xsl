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
                    
                    <li class="dropdown active">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                            Друзья <b class="caret"><xsl:text><![CDATA[]]></xsl:text></b>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="active">
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
                    
                    <li><a href="/people/{login}/groups" data-toggle="pill" data-target="#groups">Группы</a></li>
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
                <div class="pill-pane fade in active" id="friends">
                    <xsl:apply-templates select="." mode="friends-list" />
                </div>
                <div class="pill-pane fade" id="online"><xsl:text><![CDATA[]]></xsl:text></div>
                <div class="pill-pane fade" id="requests"><xsl:text><![CDATA[]]></xsl:text></div>
                <div class="pill-pane fade" id="groups"><xsl:text><![CDATA[]]></xsl:text></div>
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
    
    <xsl:template mode="friends-list" match="Person">
        <xsl:apply-templates select="friends" />
    </xsl:template>
    
    <xsl:template match="friends">
        <xsl:apply-templates select="Person" mode="friend" />
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
