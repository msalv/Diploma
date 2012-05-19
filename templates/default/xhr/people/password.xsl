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

</xsl:stylesheet>
