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
    
    <!-- Import common templates -->
    <xsl:import href="../../common.xsl" />
    
    <xsl:output
        method="xml"
        omit-xml-declaration="yes"
        encoding="UTF-8"
        indent="yes" />
   
    
    <!-- Inbox list -->
       
    <xsl:template match="dataset">
           
        <!-- Messages -->

        <xsl:apply-templates select="meta" />

        <!-- Inbox -->

        <legend>Входящие</legend>
        <xsl:apply-templates select="." mode="inbox" />
        
        <script src="/media/js/modules/mail.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>
    </xsl:template>   
    
    <xsl:template mode="inbox" match="dataset">
        
        <table class="table">
            <thead>
                <tr>
                    <th>Отправитель</th>
                    <th>Тема</th>
                    <th>Дата отправки</th>
                </tr>
            </thead>
            <tbody>
                <xsl:apply-templates select="Message" />
                <xsl:if test="not(string(.))">
                    <xsl:text><![CDATA[]]></xsl:text>
                </xsl:if>
            </tbody>
        </table>        
        
    </xsl:template>
    
    <xsl:template match="Message">
        <tr>
            <td>
                <a href="/people/{author_login}">
                    <xsl:value-of select="author_name" />
                </a>
            </td>
            <td>
                <a href="/mail/msg{@id}" data-toggle="tab" data-target="#msg">
                    <xsl:apply-templates select="." mode="subject" />
                </a>
            </td>
            <td>            
                <xsl:apply-templates select="pub_date" />
            </td>
        </tr>
    </xsl:template>
    
    <xsl:template match="Message[@unread = '1']">
        <tr>
            <td>
                <strong>
                    <a href="/people/{author_login}">
                        <xsl:value-of select="author_name" />
                    </a>
                </strong>
            </td>
            <td>
                <strong>
                    <a href="/mail/msg{@id}" data-toggle="tab" data-target="#msg">
                        <xsl:apply-templates select="." mode="subject" />
                    </a>
                </strong>
            </td>
            <td>            
                <xsl:apply-templates select="pub_date" />
            </td>
        </tr>
    </xsl:template>
    
    <xsl:template mode="subject" match="Message[not(subject)]">
        <xsl:text>(без темы)</xsl:text>
    </xsl:template>
    
    <xsl:template mode="subject" match="Message">
        <xsl:value-of select="subject" />
    </xsl:template>

    
</xsl:stylesheet>
