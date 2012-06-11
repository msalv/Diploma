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
       
    <!-- Person information  -->
       
    <xsl:template match="Person">
            
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
                                <xsl:apply-templates select="." mode="profile-picture-50" />
                            </a>
                        </div>
                        <div class="span">
                            <input type="file" class="input-xlarge" id="profile_picture" name="profile_picture" />
                            <input type="hidden" name="MAX_FILE_SIZE" value="2097152" />
                            <p><small>Максимальный размер — 2 МБ.<br/>Допустимые форматы: PNG, JPG, GIF</small></p>
                        </div>
                    </div>
                </div>

                <hr />

                <xsl:apply-templates select="." mode="login" />
                
                <div class="control-group">
                    <label for="cellphone" class="control-label">Мобильный телефон</label>
                    <div class="controls">
                        <input type="text" name="cellphone" id="cellphone" class="input-xlarge">
                            <xsl:attribute name="value">
                                <xsl:apply-templates select="cellphone"/>
                            </xsl:attribute>
                        </input>
                            <p class="help-block">
                                <small>Укажите свой мобильный телефон без плюса.
                                    <br/>Например, <strong>79119010203.</strong></small>
                            </p>
                        </div>
                </div>
                
                <hr />

                <xsl:apply-templates select="." mode="timezone" />

                <div class="form-actions">
                    <button class="btn btn btn-inverse" type="submit">Сохранить</button>
                </div>

            </fieldset>
        </form>
                        
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
                    <xsl:apply-templates select="document('../../timezones.xml')/timezones/tz">
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
      
</xsl:stylesheet>
