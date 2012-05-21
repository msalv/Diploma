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
        <xsl:text>Мероприятия</xsl:text>
    </xsl:template>
     
    <!-- Settings  -->
       
    <xsl:template match="Event">
        <div class="span3">
            
            <ul class="nav nav-tabs nav-stacked">
                <li><a href="/groups/{@blog_id}/admin/owners" data-toggle="tab" data-target="#owners">Руководство</a></li>
                <li class="active">
                    <a href="/groups/{@blog_id}/admin/events" data-toggle="tab" data-target="#events">Мероприятия</a>
                </li>
                <li><a href="/groups/{@blog_id}/admin/settings" data-toggle="tab" data-target="#settings">Настройки</a></li>
            </ul>
            
        </div>
        <div class="span9">
            
        <div class="tab-content">
            <div class="tab-pane fade" id="owners"><xsl:text><![CDATA[]]></xsl:text></div>
            <div class="tab-pane fade in active" id="events">
                
            <!-- Messages -->
            
            <xsl:apply-templates select="meta" />
            
            <legend>
                <a href="/groups/{@blog_id}" class="btn pull-right">
                    <i class="icon-arrow-left"><xsl:text><![CDATA[]]></xsl:text></i>
                    <xsl:text> к группе</xsl:text>
                </a>
                Мероприятия
            </legend>
            
            <ul class="nav nav-pills">
                <li class="active">
                    <a href="#new" data-toggle="pill">Новое</a>
                </li>
                <li>
                    <a href="#all" data-toggle="pill">Все</a>
                </li>
            </ul>
          
            <div class="pill-content">
            
                <div class="pill-pane fade in active" id="new">
            
                <!-- New event form -->

                <form class="form-horizontal" method="POST" action="/groups/{@blog_id}/admin/events">
                    <fieldset>
                        <xsl:apply-templates select="." mode="start_date" />
                        <xsl:apply-templates select="." mode="info" />

                        <div class="form-actions">
                            <button class="btn btn btn-inverse" type="submit">Добавить</button>
                        </div>

                    </fieldset>
                </form>
            
                </div>
                
                <div class="pill-pane fade" id="all">
                    <xsl:text><![CDATA[]]></xsl:text>
                </div>
            
            </div>
                
            </div>
            <div class="tab-pane fade" id="settings"><xsl:text><![CDATA[]]></xsl:text></div>
        </div>
                       
        </div>
    </xsl:template>
    
    <!-- Scripts -->
    
    <xsl:template mode="scripts" match="/">
        <script src="/media/js/modules/settings.js">
            <xsl:text><![CDATA[]]></xsl:text>
        </script>
        <script>
            (function($) {
                $('div#all').load('/groups/<xsl:value-of select="/Event/@blog_id"/>/events');
            })(jQuery);
        </script>
    </xsl:template>

    <!-- Start date -->

    <xsl:template mode="start_date" match="Event">
        <div class="control-group">
            <label class="control-label" for="day">
                <xsl:text>День проведения</xsl:text>
            </label>
            <div class="controls">
                <input type="text" class="span1 inline" id="day" name="day">
                    <xsl:attribute name="value">
                        <xsl:value-of select="current()/start_date/@day" />
                    </xsl:attribute>
                </input>
                <select class="inline span2" id="month" name="month">
                    <xsl:apply-templates select="document('../calendar.xml')/months/item">
                        <xsl:with-param name="month" select="current()/start_date/@month"/>
                    </xsl:apply-templates>
                </select>
                <select class="inline" style="width:72px;" id="year" name="year">
                    <xsl:call-template name="years">
                        <xsl:with-param name="count" select="date:year() + 5"/>
                    </xsl:call-template>
                </select>
                
            </div>
        </div>
    </xsl:template>
    
    <xsl:template name="years">
        <xsl:param name="count" select="1"/>

        <xsl:if test="$count >= date:year()">
            <option value="{$count}">
                <xsl:if test="$count = current()/start_date/@year">
                    <xsl:attribute name="selected">
                        <xsl:text>selected</xsl:text>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$count" />
            </option>
            <xsl:call-template name="years">
                <xsl:with-param name="count" select="$count - 1"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>
    
    <xsl:template match="item">
        <xsl:param name="month" />
        <option>
            <xsl:attribute name="value">
                <xsl:value-of select="position()" />
            </xsl:attribute>
            <xsl:if test="position() = number($month)" >
            <xsl:attribute name="selected">
                <xsl:text>selected</xsl:text>
            </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
        </option>
    </xsl:template>
           
    <!-- Info -->
    
    <xsl:template mode="info" match="Event">
        <xsl:call-template name="textarea">
            <xsl:with-param name="id" select="'info'" />
            <xsl:with-param name="title" select="'Описание'" />
        </xsl:call-template>
    </xsl:template>
    
    <!-- List mode -->
    
    <xsl:template match="dataset">
        <div class="span9">
            <div class="page-header">
                <a href="javascript:history.go(-1);" class="btn pull-right">
                    <i class="icon-arrow-left"><xsl:text><![CDATA[]]></xsl:text></i>
                    <xsl:text> вернуться</xsl:text>
                </a>
                <h1>Мероприятия</h1>
            </div>
                       
            <xsl:apply-templates select="Event" mode="list" />
            
            <xsl:if test="not(string(.))">
                <div class="alert">Мероприятий нет</div>
            </xsl:if>
            
        </div>
        
    </xsl:template>
    
    <xsl:template match="Event" mode="list">
        
        <h2>
            <xsl:value-of select="number(start_date/@day)" />
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="document('../calendar.xml')/months/item" mode="list">
                <xsl:with-param name="month" select="current()/start_date/@month"/>
            </xsl:apply-templates>
            <xsl:text> </xsl:text>
            <xsl:value-of select="start_date/@year" />
            <xsl:text> г.</xsl:text>
        </h2>
        
        <p>
            <xsl:value-of select="info" />
        </p>
        
        <!-- Add horizontal line if not last -->
        <xsl:if test="position() != last()">
            <hr/>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="item" mode="list">
        <xsl:param name="month" />
            <xsl:if test="position() = number($month)" >
                <xsl:value-of select="."/>
            </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
