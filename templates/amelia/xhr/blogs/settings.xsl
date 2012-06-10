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
    <xsl:import href="../../forms.xsl" />
    <!-- Import common templates -->
    <xsl:import href="../../common.xsl" />
    
    <xsl:output
        method="xml"
        omit-xml-declaration="yes"
        encoding="UTF-8"
        indent="yes" />
    
    <!-- Blog information  -->
       
    <xsl:template match="Blog">
           
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

                <xsl:apply-templates select="." mode="type" />
                
                <hr />
                
                <xsl:apply-templates select="." mode="locked" />

                <div class="form-actions">
                    <button class="btn btn-inverse" type="submit">Сохранить</button>
                </div>

            </fieldset>
        </form>
            
    </xsl:template>
    
    <!-- Title -->

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
    
    <!-- type -->
    
    <!-- List of types  -->
    
    <xsl:variable name="radios">
        <radio id="2" name="dafault">
            <xsl:text>обычная</xsl:text>
        </radio>
        <radio id="3" name="student">
            <xsl:text>студенческая</xsl:text>
        </radio>
    </xsl:variable>
   
   <!-- Type control group -->
    
    <xsl:template mode="type" match="Blog">
        
        <div class="control-group">
            <label class="control-label">Тип группы</label>
            <div class="controls">
                
                <xsl:apply-templates select="exsl:node-set($radios)/radio" mode="check_radio">
                    <xsl:with-param name="value" select="@type" />
                </xsl:apply-templates>
                
            </div>
        </div>
    </xsl:template>
    
    <!-- Transform radios to radio buttons checking right option -->
    
    <xsl:template mode="check_radio" match="radio">
        <xsl:param name="value" />
        
        <label class="radio">
            <input type="radio" value="{@id}" id="{@name}" name="type">
                <xsl:if test="$value = @id">
                    <xsl:attribute name="checked">
                        <xsl:text>checked</xsl:text>
                    </xsl:attribute>
                </xsl:if>
            </input>
            <xsl:value-of select="." />
        </label>
        
    </xsl:template>
    
</xsl:stylesheet>
