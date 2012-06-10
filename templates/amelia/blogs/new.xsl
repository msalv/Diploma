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
        <xsl:text>Новая группа</xsl:text>
    </xsl:template>
     
    <!-- Person information  -->
       
    <xsl:template match="Blog">

        <div class="offset2 span9">
                       
            <!-- Messages -->
            
            <xsl:apply-templates select="meta" />
          
            <!-- Settings -->
            
            <form class="form-horizontal" method="POST" action="/groups/new">
                <fieldset>
                <legend>Новая группа</legend>
                    
                    <xsl:apply-templates select="." mode="title" />
                    <xsl:apply-templates select="." mode="info" />
                    
                    <hr />
                    
                    <!--<xsl:apply-templates select="." mode="type" />-->
                    <xsl:apply-templates select="." mode="locked" />
                    
                    <div class="form-actions">
                        <button class="btn btn-inverse" type="submit">Создать</button> 
                        <a class="btn" href="/groups">Отмена</a>
                    </div>
                    
                </fieldset>
            </form>                       
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
