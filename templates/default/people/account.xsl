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
    
    <xsl:output
        method="xml"
        omit-xml-declaration="yes"
        doctype-system="about:legacy-compat"
        encoding="UTF-8"
        indent="yes" />

    <!-- Include base template -->
    <xsl:include href="../default.xsl" />
    
    <xsl:template mode="title" match="/">
        <xsl:text>Настройки</xsl:text>
    </xsl:template>
     
    <!-- Person information  -->
       
    <xsl:template match="Person">
        <div class="span3">
            
            <ul class="nav nav-tabs nav-stacked">
                <li><a href="/settings/profile">Профиль</a></li>
                <li class="active">
                    <a href="/settings/account">Аккаунт</a>
                </li>
                <li><a href="/settings/password">Пароль</a></li>
                <li><a href="#">Приватность</a></li>
                <li><a href="#">Оповещения</a></li>
            </ul>
            
        </div>
        <div class="span9">
            
            <!-- Messages -->
            
            <xsl:apply-templates select="meta" />
          
            <!-- Account -->
            
            <form class="form-horizontal" method="POST" action="/settings/account/" enctype="multipart/form-data">
                <fieldset>
                <legend>Аккаунт</legend>
                    
                    <div class="control-group">
                        <label for="profile_picture" class="control-label">
                            Фотография
                        </label>
                        <div class="controls">
                            <div class="span1">
                                <a class="thumbnail">
                                    <xsl:apply-templates select="." mode="profile-picture" />
                                </a>
                            </div>
                            <div class="span">
                                <input type="file" class="input-xlarge" id="profile_picture" name="profile_picture" />
                                <p><small>Максимальный размер — 2 МБ.<br/>Допустимые форматы: PNG, JPG, GIF</small></p>
                            </div>
                        </div>
                    </div>

                    <hr />
                    
                    <xsl:apply-templates select="." mode="login" />
                    
                    <hr />
                    
                    <xsl:apply-templates select="." mode="timezone" />
                                        
                    <div class="form-actions">
                        <button class="btn btn btn-inverse" type="submit">Сохранить</button>
                    </div>
                    
                </fieldset>
            </form>
                        
        </div>
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

    <!-- Login -->
    
    <xsl:template mode="login" match="Person">
        <xsl:call-template name="input">
            <xsl:with-param name="id" select="'login'" />
            <xsl:with-param name="title" select="'Логин'" />
        </xsl:call-template>
    </xsl:template>
    
    <!-- Timezone -->
         
    <xsl:template mode="timezone" match="Person">
        <div class="control-group">
            <label class="control-label" for="timezone">
                <xsl:text>Часовой пояс</xsl:text>
            </label>
            <div class="controls">
                <select class="inline" id="timezone" name="timezone">
                    <xsl:apply-templates select="document('../timezones.xml')/timezones/tz">
                        <xsl:with-param name="current" select="current()/timezone"/>
                    </xsl:apply-templates>
                </select>                
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="tz">
        <xsl:param name="current" />
        <option>
            <xsl:attribute name="value">
                <xsl:value-of select="@value" />
            </xsl:attribute>
            <xsl:if test="@value = $current" >
            <xsl:attribute name="selected">
                <xsl:text>selected</xsl:text>
            </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
        </option>
    </xsl:template>
      
    <!-- messages -->
    
    <xsl:template match="meta">
        <xsl:apply-templates select="message" />
    </xsl:template>
    
    <xsl:template match="message">
        <div class="alert alert-{@type}">
            <xsl:apply-templates />
        </div>
    </xsl:template>

</xsl:stylesheet>
