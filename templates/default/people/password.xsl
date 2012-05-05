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
                <li>
                    <a href="/settings/account">Аккаунт</a>
                </li>
                <li class="active">
                    <a href="/settings/password">Пароль</a>
                </li>
                <li><a href="#">Приватность</a></li>
                <li><a href="#">Оповещения</a></li>
            </ul>
            
        </div>
        <div class="span9">
            
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
