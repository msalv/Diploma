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
        <xsl:text>Настройки</xsl:text>
    </xsl:template>
     
    <!-- Person information  -->
       
    <xsl:template match="Person">
        <div class="span3">
            
            <ul class="nav nav-tabs nav-stacked">
                <li><a href="/settings/profile" data-toggle="tab" data-target="#profile">Профиль</a></li>
                <li><a href="/settings/account" data-toggle="tab" data-target="#account">Аккаунт</a></li>
                <li class="active">
                    <a href="/settings/password" data-toggle="tab" data-target="#password">Пароль</a>
                </li>
                <li><a href="/settings/privacy" data-toggle="tab" data-target="#privacy">Приватность</a></li>
            </ul>
            
        </div>
        <div class="span9">
        <div class="tab-content">
            
            <div class="tab-pane fade" id="profile"><xsl:text><![CDATA[]]></xsl:text></div>
            <div class="tab-pane fade" id="account"><xsl:text><![CDATA[]]></xsl:text></div>
            
            <div class="tab-pane fade in active" id="password">
            <!-- Messages -->
            
            <xsl:apply-templates select="meta" />
          
            <!-- password -->
            
            <form class="form-horizontal" method="POST" action="/settings/password/">
                <fieldset>
                <legend>Пароль</legend>
                                      
                    <xsl:apply-templates select="." mode="currpass" />
                    
                    <xsl:apply-templates select="." mode="newpass" />
                                                           
                    <div class="form-actions">
                        <button class="btn btn btn-inverse" type="submit">Сохранить</button>
                    </div>
                    
                </fieldset>
            </form>
            </div>

            <div class="tab-pane fade" id="privacy"><xsl:text><![CDATA[]]></xsl:text></div>
        </div>
        </div>
    </xsl:template>

    <!-- Current password -->
    
    <xsl:template mode="currpass" match="Person">
        <xsl:call-template name="input-password">
            <xsl:with-param name="id" select="'currpass'" />
            <xsl:with-param name="title" select="'Текущий пароль'" />
        </xsl:call-template>
    </xsl:template>
    
    <!-- New password -->
    
    <xsl:template mode="newpass" match="Person">
        <xsl:call-template name="input-password">
            <xsl:with-param name="id" select="'password'" />
            <xsl:with-param name="title" select="'Новый пароль'" />
        </xsl:call-template>
    </xsl:template>
                 
    <!-- Scripts -->
    
    <xsl:template mode="scripts" match="/">
        <script src="/media/js/modules/settings.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>
    </xsl:template>

</xsl:stylesheet>
