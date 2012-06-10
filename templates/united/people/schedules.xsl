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
        Расписания
    </xsl:template>
  
    <!-- Person information  -->
       
    <xsl:template match="dataset">
        <div class="span9">
            <div class="page-header">
                <h1>
                    Расписания
                </h1>
            </div>
            
            <xsl:apply-templates select="Blog" />
            <xsl:if test="not(string(.))">
                <div class="alert alert-info">
                    Вы не состоите в студенческих группах
                </div>
            </xsl:if>
            
        </div>
               
    </xsl:template>
    
    <xsl:template mode="scripts" match="/">
        <script src="/media/js/modules/people.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>
    </xsl:template>
            
    <!-- 
        Blog schedule template
    -->
    
    <xsl:template match="Blog[not(schedule)]"/>
       
    <xsl:template match="Blog">
        
        <h3 style="margin: 0 0 9px;">
            <a href="/groups/{@id}">
                <xsl:value-of select="title" />
            </a>
        </h3>
        
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Время</th>
                    <th>Предмет</th>
                    <th>Преподаватель</th>
                </tr>
            </thead>
            <tbody>
                <xsl:apply-templates select="document(schedule)" mode="doc" />
            </tbody>
        </table>
        
    </xsl:template>
    
    <xsl:template mode="doc" match="/">
      
        <xsl:apply-templates select="schedule" mode="doc" />
        
    </xsl:template>
    
    <xsl:template mode="doc" match="schedule">
      
        <xsl:apply-templates select="week" mode="doc" />
        
    </xsl:template>
    
    <xsl:template mode="doc" match="week">
      
        <xsl:if test="date:week-in-year() mod 2 = 0">
            <xsl:if test="@order = 'bottom'">
                <xsl:apply-templates select="day" mode="doc" />
            </xsl:if>
        </xsl:if>
        
        <xsl:if test="date:week-in-year() mod 2 = 1">
            <xsl:if test="@order = 'top'">
                <xsl:apply-templates select="day" mode="doc" />
            </xsl:if>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template mode="doc" match="day">
        
        <tr>
            <td colspan="3" style="text-align:center;">
                <xsl:value-of select="title" />
            </td>
        </tr>
        <xsl:apply-templates select="subject" mode="doc" />
        
    </xsl:template>
    
    <xsl:template mode="doc" match="subject">
      
        <tr>
            <td>
                <xsl:value-of select="time" />
            </td>
            <td>
                <xsl:value-of select="title" />
            </td>
            <td>
                <xsl:value-of select="lecturer" />
            </td>
        </tr>
        
    </xsl:template>
                 
</xsl:stylesheet>
