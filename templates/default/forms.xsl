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
    
    <!-- Wall form template -->
    
    <xsl:template name="wall-form">
        <xsl:param name="login" />
        <xsl:param name="locked" />
        
        <hr />

        <xsl:if test="$locked = 0">
        <form id="wall-posting" class="well" action="/people/{$login}" method="POST">
            <textarea id="content" name="content" rows="1" style="width:98%;" placeholder="Напишите сообщение...">
                <xsl:text><![CDATA[]]></xsl:text>
            </textarea>
            <button type="submit" class="btn">Отправить</button>
        </form>
        </xsl:if>
    </xsl:template>
    
    <!--
        Subscribe/Send PM buttons
    -->
    
    <xsl:template name="non-friend-actions">
        
        <xsl:param name="friend_id" />
        
        <div class="btn-group pull-right">

            <a class="btn dropdown-toggle" data-toggle="dropdown" href="#" rel="tooltip" title="Меню пользователя">
                <i class="icon-tasks">
                    <xsl:text><![CDATA[]]></xsl:text>    
                </i>
                <xsl:text> </xsl:text>
                <span class="caret">
                    <xsl:text><![CDATA[]]></xsl:text>    
                </span>
            </a>

            <ul class="dropdown-menu">
                <li>
                    <a href="/people/mail/{$friend_id}" id="send-pm">
                        <i class="icon-share-alt">
                            <xsl:text><![CDATA[]]></xsl:text>
                        </i>
                        <xsl:text> Написать</xsl:text>
                    </a>
                </li>
                <li class="divider">
                    <xsl:text><![CDATA[]]></xsl:text>    
                </li>
                <li>
                    <a href="/people/add/{$friend_id}" id="add-friend">
                        <i class="icon-plus">
                            <xsl:text><![CDATA[]]></xsl:text>
                        </i>
                        <xsl:text> Добавить в друзья</xsl:text>
                    </a>
                </li>
            </ul>

        </div>
    </xsl:template>
    
    <xsl:template name="friend-actions">
        <xsl:param name="friend_id" />
        
        <div class="btn-group pull-right">

            <a class="btn dropdown-toggle" data-toggle="dropdown" href="#" rel="tooltip" title="Меню пользователя">
                <i class="icon-tasks">
                    <xsl:text><![CDATA[]]></xsl:text>    
                </i>
                <xsl:text> </xsl:text>
                <span class="caret">
                    <xsl:text><![CDATA[]]></xsl:text>
                </span>
            </a>

            <ul class="dropdown-menu">
                <li>
                    <a href="/people/mail/{$friend_id}" id="send-pm">
                        <i class="icon-share-alt">
                            <xsl:text><![CDATA[]]></xsl:text>
                        </i>
                        <xsl:text> Написать</xsl:text>
                    </a>
                </li>
                <li class="divider">
                    <xsl:text><![CDATA[]]></xsl:text>    
                </li>
                <li>
                    <a href="/people/remove/{$friend_id}" id="remove-friend">
                        <i class="icon-remove">
                            <xsl:text><![CDATA[]]></xsl:text>
                        </i>
                        <xsl:text> Убрать из друзей</xsl:text>
                    </a>
                </li>
            </ul>

        </div>
    </xsl:template>
    
    <!--
        User actions
    -->
    
    <xsl:template mode="user-actions" match="Person[not(is_friend)]">
        <xsl:call-template name="non-friend-actions" >
            <xsl:with-param name="friend_id" select="@id" />
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template mode="user-actions" match="Person">
        <xsl:call-template name="friend-actions" >
            <xsl:with-param name="friend_id" select="@id" />
        </xsl:call-template>
    </xsl:template>
    
   <!-- Blog form template -->
    
    <xsl:template name="blog-form">
        <xsl:param name="blog_id" />
        <xsl:param name="locked" />
        
        <xsl:if test="$locked = 0">
        <form id="blog-posting" class="well" action="/groups/{$blog_id}" method="POST" enctype="multipart/form-data">
            <input type="text" class="input-xlarge" name="title" id="title" placeholder="Заголовок" />
            <textarea id="content" name="content" rows="1" style="width:98%;" placeholder="Напишите сообщение...">
                <xsl:text><![CDATA[]]></xsl:text>
            </textarea>
            <button type="submit" class="btn btn-info">Отправить</button>
            <!--<button class="btn" id="attach" type="button">Прикрепить...</button>-->
        </form>
        </xsl:if>
    </xsl:template>
    

</xsl:stylesheet>
