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

        <!-- password -->

        <form class="form-horizontal" method="POST" action="/settings/privacy">
            <fieldset>
            <legend>Приватность</legend>

                <div class="alert alert-info">Укажите данные, которыми бы вы не хотели делиться с окружающими.</div>

                <xsl:apply-templates select="." mode="privacy-settings" />

                <div class="form-actions">
                    <button class="btn btn-inverse" type="submit">Сохранить</button>
                </div>

            </fieldset>
        </form>
            
    </xsl:template>

    <!-- Privacy checkboxes -->
    
    <xsl:template mode="privacy-settings" match="Person">
        <div class="control-group">
            <label for="optionsCheckboxList" class="control-label">Скрыть</label>
            <div class="controls">
                
                <label class="checkbox">
                    <input type="checkbox" value="1" name="wall">
                        <xsl:if test="@privacy_wall = '1'">
                            <xsl:attribute name="checked">
                                <xsl:text>checked</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                    </input>
                    <xsl:text>стену</xsl:text>
                </label>
                
                <label class="checkbox">
                    <input type="checkbox" value="1" name="info">
                        <xsl:if test="@privacy_info = '1'">
                            <xsl:attribute name="checked">
                                <xsl:text>checked</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                    </input>
                    <xsl:text>личные данные</xsl:text>
                </label>
                
                <label class="checkbox">
                    <input type="checkbox" value="1" name="friends">
                        <xsl:if test="@privacy_friends = '1'">
                            <xsl:attribute name="checked">
                                <xsl:text>checked</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                    </input>
                    <xsl:text>друзей</xsl:text>
                </label>
                
                <p class="help-block">
                    Учтите, что эти данные будут доступны только вашим <strong>друзьям.</strong>
                </p>
            </div>
        </div>
    </xsl:template>
                 
</xsl:stylesheet>
