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

        <!-- Profile -->

        <form class="form-horizontal" method="POST" action="/settings/">
            <fieldset>
            <legend>Профиль</legend>

                <xsl:apply-templates select="." mode="last_name" />
                <xsl:apply-templates select="." mode="first_name" />
                <xsl:apply-templates select="." mode="middle_name" />
                <xsl:apply-templates select="." mode="date_of_birth" />
                <xsl:apply-templates select="." mode="gender" />

                <hr />

                <xsl:apply-templates select="." mode="location" />
                <xsl:apply-templates select="." mode="hometown" />

                <hr />

                <xsl:apply-templates select="." mode="work_phone" />
                <xsl:apply-templates select="." mode="home_phone" />

                <hr />

                <xsl:apply-templates select="." mode="info" />

                <div class="form-actions">
                    <button class="btn btn btn-inverse" type="submit">Сохранить</button>
                </div>

            </fieldset>
        </form>

    </xsl:template>
    
    <!-- First name -->

    <xsl:template mode="first_name" match="Person">
        <xsl:call-template name="input">
            <xsl:with-param name="id" select="'first_name'" />
            <xsl:with-param name="title" select="'Имя'" />
        </xsl:call-template>
    </xsl:template>

    <!-- Last name -->
    
    <xsl:template mode="last_name" match="Person">
        <xsl:call-template name="input">
            <xsl:with-param name="id" select="'last_name'" />
            <xsl:with-param name="title" select="'Фамилия'" />
        </xsl:call-template>
    </xsl:template>
    
    <!-- Middle name -->
      
    <xsl:template mode="middle_name" match="Person">
        <xsl:call-template name="input">
            <xsl:with-param name="id" select="'middle_name'" />
            <xsl:with-param name="title" select="'Отчество'" />
        </xsl:call-template>
    </xsl:template>
    
    <!-- Date of birth -->
    
    <xsl:template mode="date_of_birth" match="Person">
        <div class="control-group">
            <label class="control-label" for="day">
                <xsl:text>День рождения</xsl:text>
            </label>
            <div class="controls">
                <input type="text" class="span1 inline" id="day" name="day">
                    <xsl:attribute name="value">
                        <xsl:value-of select="number(current()/date_of_birth/@day)" />
                    </xsl:attribute>
                </input>
                <select class="inline span2" id="month" name="month">
                    <xsl:apply-templates select="document('../../calendar.xml')/months/item">
                        <xsl:with-param name="month" select="current()/date_of_birth/@month"/>
                    </xsl:apply-templates>
                </select>
                <select class="inline" style="width:72px;" id="year" name="year">
                    <xsl:call-template name="years">
                        <xsl:with-param name="count" select="date:year() - 13"/>
                    </xsl:call-template>
                </select>
                
            </div>
        </div>
    </xsl:template>
    
    <xsl:template name="years">
        <xsl:param name="count" select="1"/>

        <xsl:if test="$count >= date:year() - 90">
            <option value="{$count}">
                <xsl:if test="$count = current()/date_of_birth/@year">
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
    
    <!-- Current location -->
    
    <xsl:template mode="location" match="Person">
        <xsl:call-template name="input">
            <xsl:with-param name="id" select="'location'" />
            <xsl:with-param name="title" select="'Местоположение'" />
        </xsl:call-template>
    </xsl:template>
    
    <!-- Hometown -->
    
    <xsl:template mode="hometown" match="Person">
        <xsl:call-template name="input">
            <xsl:with-param name="id" select="'hometown'" />
            <xsl:with-param name="title" select="'Родной город'" />
        </xsl:call-template>
    </xsl:template>
    
    <!-- Work phone -->
    
    <xsl:template mode="work_phone" match="Person">
        <xsl:call-template name="input">
            <xsl:with-param name="id" select="'work_phone'" />
            <xsl:with-param name="title" select="'Рабочий телефон'" />
        </xsl:call-template>
    </xsl:template>
    
    <!-- Home phone -->
    
    <xsl:template mode="home_phone" match="Person">
        <xsl:call-template name="input">
            <xsl:with-param name="id" select="'home_phone'" />
            <xsl:with-param name="title" select="'Домашний телефон'" />
        </xsl:call-template>
    </xsl:template>
    
    <!-- Info -->
    
    <xsl:template mode="info" match="Person">
        <xsl:call-template name="textarea">
            <xsl:with-param name="id" select="'info'" />
            <xsl:with-param name="title" select="'О себе'" />
        </xsl:call-template>
    </xsl:template>
       
    <!-- 
        Checking gender radio button
    -->
    
    <!-- List of genders  -->
    
    <xsl:variable name="radios">
        <radio id="1" name="male">
            <xsl:text>мужской</xsl:text>
        </radio>
        <radio id="0" name="female">
            <xsl:text>женский</xsl:text>
        </radio>
    </xsl:variable>
   
   <!-- Gender control group -->
    
    <xsl:template mode="gender" match="Person">
        
        <div class="control-group">
            <label class="control-label">Пол</label>
            <div class="controls">
                
                <xsl:apply-templates select="exsl:node-set($radios)/radio" mode="check_radio">
                    <xsl:with-param name="value" select="@gender" />
                </xsl:apply-templates>
                
            </div>
        </div>
    </xsl:template>
    
    <!-- Transform radios to radio buttons checking right option -->
    
    <xsl:template mode="check_radio" match="radio">
        <xsl:param name="value" />
        
        <label class="radio">
            <input type="radio" value="{@id}" id="{@name}" name="gender">
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
