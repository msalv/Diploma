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
                    <li class="active"><a href="/people/{login}/profile" data-toggle="pill" data-target="#profile">Профиль</a></li>
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
                <div class="pill-pane fade in active" id="profile">
                    <xsl:apply-templates select="." mode="user-info" />
                </div>
                <div class="pill-pane fade" id="friends"><xsl:text><![CDATA[]]></xsl:text></div>
                <div class="pill-pane fade" id="requests"><xsl:text><![CDATA[]]></xsl:text></div>
                <div class="pill-pane fade" id="online"><xsl:text><![CDATA[]]></xsl:text></div>
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
