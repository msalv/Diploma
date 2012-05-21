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
       
    <xsl:template match="Blog">
        <div class="span3">
            
            <ul class="nav nav-tabs nav-stacked">
                <li><a href="/groups/{@id}/admin/owners" data-toggle="tab" data-target="#owners">Руководство</a></li>
                <li><a href="/groups/{@id}/admin/events" data-toggle="tab" data-target="#events">Мероприятия</a></li>
                <li class="active">
                    <a href="/groups/{@id}/admin/settings" data-toggle="tab" data-target="#settings">Настройки</a>
                </li>
            </ul>
            
        </div>
        <div class="span9">
            
        <div class="tab-content">
            <div class="tab-pane fade" id="owners"><xsl:text><![CDATA[]]></xsl:text></div>
            <div class="tab-pane fade" id="events"><xsl:text><![CDATA[]]></xsl:text></div>
            <div class="tab-pane fade in active" id="settings">
            
            <!-- Messages -->
            
            <xsl:apply-templates select="meta" />
          
            <!-- Settings -->
            
            <form class="form-horizontal" method="POST" action="/groups/{@id}/admin/settings">
                <fieldset>
                <legend>
                    <a href="/groups/{@id}" class="btn pull-right">
                        <i class="icon-arrow-left"><xsl:text><![CDATA[]]></xsl:text></i>
                        <xsl:text> к группе</xsl:text>
                    </a>
                    Настройки группы
                </legend>
                    
                    <xsl:apply-templates select="." mode="title" />
                    <xsl:apply-templates select="." mode="info" />
                    
                    <hr />
                    
                    <!--<xsl:apply-templates select="." mode="type" />-->
                    <xsl:apply-templates select="." mode="locked" />
                    
                    <div class="form-actions">
                        <button class="btn btn-inverse" type="submit">Сохранить</button>
                    </div>
                    
                </fieldset>
            </form>
            
            </div>
        </div>
                       
        </div>
    </xsl:template>
    
    <!-- Scripts -->
    
    <xsl:template mode="scripts" match="/">
        <script src="/media/js/modules/owners.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>
        <script src="/media/js/modules/settings.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>
    </xsl:template>

    <!-- First name -->

    <xsl:template mode="title" match="Blog">
        <xsl:call-template name="input">
            <xsl:with-param name="id" select="'title'" />
            <xsl:with-param name="title" select="'Название'" />
        </xsl:call-template>
    </xsl:template>
  
    <!-- Locked -->
    
    <xsl:template mode="locked" match="Blog">
        <div class="control-group">
            <label class="control-label" for="locked">
                <xsl:text>Приватность</xsl:text>
            </label>
            <div class="controls">
                <label class="checkbox">
                    <input type="checkbox" name="locked" value="1">
                        <xsl:if test="@locked = 1">
                            <xsl:attribute name="checked">
                                <xsl:text>checked</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                    </input>
                    <xsl:text> закрытая группа</xsl:text>
                </label>
            </div>
        </div>
    </xsl:template>
          
    <!-- Info -->
    
    <xsl:template mode="info" match="Blog">
        <xsl:call-template name="textarea">
            <xsl:with-param name="id" select="'info'" />
            <xsl:with-param name="title" select="'Описание'" />
        </xsl:call-template>
    </xsl:template>
    
</xsl:stylesheet>
