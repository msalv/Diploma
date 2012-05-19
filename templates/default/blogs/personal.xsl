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
        <xsl:apply-templates select="Blog/owners/Person" mode="full-name" />
    </xsl:template>
  
    <!-- Person information  -->
       
    <xsl:template match="Blog">
        <div class="span3">
            <xsl:apply-templates select="./owners/Person" mode="profile-picture" />
            
            <xsl:if test="./owners/Person/@id = $id">
                <div id="sidebar-requests"><xsl:text><![CDATA[]]></xsl:text></div>
            </xsl:if>
            
            <div id="sidebar-friends"><xsl:text><![CDATA[]]></xsl:text></div>
            <div id="sidebar-groups"><xsl:text><![CDATA[]]></xsl:text></div>
        </div>
        <div class="span9">
            <div class="page-header">
                
                <xsl:if test="./owners/Person/@id != $id">
                    <xsl:apply-templates select="owners/Person" mode="user-actions" />
                </xsl:if>
                
                <h1>
                    <xsl:apply-templates select="./owners/Person" mode="full-name" />
                </h1>
            </div>
            
            <div class="subnav">
                <ul class="nav nav-pills">
                    <li class="active"><a href="/people/{owners/Person/login}/wall" data-toggle="pill" data-target="#wall">Стена</a></li>
                    <li><a href="/people/{owners/Person/login}/profile" data-toggle="pill" data-target="#profile">Профиль</a></li>
                    
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                            Друзья <b class="caret"><xsl:text><![CDATA[]]></xsl:text></b>
                        </a>
                        <ul class="dropdown-menu">
                            <li>
                                <a href="/people/{owners/Person/login}/friends" data-toggle="pill" data-target="#friends">Все друзья</a>
                            </li>
                            <li>
                                <a href="/people/{owners/Person/login}/friends" data-toggle="pill" data-target="#online">Онлайн</a>
                            </li>
                            <xsl:if test="@id = $id">
                                <li class="divider"><xsl:text><![CDATA[]]></xsl:text></li>
                                <li><a href="/people/friends/requests" data-toggle="pill" data-target="#requests">Заявки</a></li>
                            </xsl:if>
                        </ul>
                    </li>
                    
                    <li><a href="/people/{owners/Person/login}/groups" data-toggle="pill" data-target="#groups">Группы</a></li>
                </ul>
            </div>
            
            <div class="pill-content">
                <div class="pill-pane fade in active" id="wall">
                    
                    <xsl:call-template name="wall-form">
                        <xsl:with-param name="login" select="owners/Person/login" />
                        <xsl:with-param name="locked" select="current()/@locked" />
                    </xsl:call-template>
                    
                    <div id="posts">
                        <xsl:apply-templates select="." mode="posts" />
                    </div>
                    
                </div>
                
                <div class="pill-pane fade" id="profile"><xsl:text><![CDATA[]]></xsl:text></div>
                <div class="pill-pane fade" id="friends"><xsl:text><![CDATA[]]></xsl:text></div>
                <div class="pill-pane fade" id="online"><xsl:text><![CDATA[]]></xsl:text></div>
                <div class="pill-pane fade" id="requests"><xsl:text><![CDATA[]]></xsl:text></div>
                <div class="pill-pane fade" id="groups"><xsl:text><![CDATA[]]></xsl:text></div>
            </div>
            
        </div>
    </xsl:template>
    
    <xsl:template mode="scripts" match="/">
        <script src="/media/js/modules/people.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>

        <xsl:call-template name="user-sidebar">
            <xsl:with-param select="/Blog/owners/Person/login" name="login"/>
        </xsl:call-template>
        
    </xsl:template>
       
    <!-- 
        Wall template
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
        <xsl:text>На этой стене разрешили писать только друзьям</xsl:text>
    </xsl:template>
    
    <xsl:template mode="posts" match="Blog">
        <xsl:apply-templates select="posts" />
    </xsl:template>
    
    <xsl:template match="posts">
        <xsl:apply-templates select="Post" />
    </xsl:template>
    
    <xsl:template match="Post">
        <div class="row">
            <div class="span1">
                <a href="/people/{author_login}" class="thumbnail">
                    <xsl:apply-templates mode="profile-picture" select="." />
                </a>
            </div>
            <div class="span8">
                <p>
                    <a href="/people/{author_login}">
                        <xsl:value-of select="author_name" />
                    </a>
                </p>
                <!--<p>-->
                    <xsl:value-of select="content" disable-output-escaping="yes" />
                <!--</p>-->
                <p>
                    <small>
                        <xsl:apply-templates select="pub_date" />
                        <xsl:text> | </xsl:text>
                            <a href="/people/{/Blog/owners/Person/login}/wall/post/{@id}">
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
          
    <!-- 
        Profile picture templates 
    -->
    
    <!-- Profile picture is not set -->
    
    <xsl:template mode="profile-picture" match="Post[not(author_pic)]">
        <xsl:apply-templates select="." mode="gender-picture" />
    </xsl:template>
    
    <!-- Female default picture -->
    
    <xsl:template mode="gender-picture" match="Post[@author_gender='0']">
        <img src="/media/img/female_50.png" class="profile-small" />
    </xsl:template>
    
    <!-- Male default picture -->
    
    <xsl:template mode="gender-picture" match="Post">
        <img src="/media/img/male_50.png" class="profile-small" />
    </xsl:template>
    
    <!-- Profile picture is set -->
    
    <xsl:template mode="profile-picture" match="Post">
        <img src="/media/thumbs/{author_pic}/{@author_id}.jpg" class="profile-small" />
    </xsl:template>
    
</xsl:stylesheet>
