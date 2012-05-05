<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : forms.xsl
    Created on : March 20, 2012, 2:28 PM
    Author     : msalv
    Description:
        Holds named templates for common forms elements
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">

    <!-- Template for input field -->
    
    <xsl:template name="input">
        
        <xsl:param name="id" />
        <xsl:param name="title" />
        
        <div class="control-group">
            <label class="control-label" for="{$id}">
                <xsl:value-of select="$title" />
            </label>
            <div class="controls">
                <input type="text" class="input-xlarge" id="{$id}" name="{$id}">
                    <xsl:if test="*[name()=$id]">
                    <xsl:attribute name="value">
                        <xsl:value-of select="*[name()=$id]" />
                    </xsl:attribute>
                    </xsl:if>
                </input>
            </div>
        </div>
        
    </xsl:template>
    
    <!-- Template for password field -->
    
    <xsl:template name="input-password">
        
        <xsl:param name="id" />
        <xsl:param name="title" />
        
        <div class="control-group">
            <label class="control-label" for="{$id}">
                <xsl:value-of select="$title" />
            </label>
            <div class="controls">
                <input type="password" class="input-xlarge" id="{$id}" name="{$id}">
                    <xsl:if test="*[name()=$id]">
                    <xsl:attribute name="value">
                        <xsl:value-of select="*[name()=$id]" />
                    </xsl:attribute>
                    </xsl:if>
                </input>
            </div>
        </div>
        
    </xsl:template>
    
    <!-- Template for textarea -->
    
    <xsl:template name="textarea">
        
        <xsl:param name="id" />
        <xsl:param name="title" />
        
        <div class="control-group">
            <label class="control-label" for="{$id}">
                <xsl:value-of select="$title" />
            </label>
            <div class="controls">
                <textarea rows="3" id="{$id}" class="input-xlarge" name="{$id}">
                    <xsl:text><![CDATA[]]></xsl:text>
                    <xsl:value-of select="*[name()=$id]" />
                </textarea>
            </div>
        </div>
        
    </xsl:template>

</xsl:stylesheet>
