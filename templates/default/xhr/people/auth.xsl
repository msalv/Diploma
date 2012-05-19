<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : auth.xsl
    Created on : March 17, 2012, 10:21 PM
    Author     : Кирилл
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output
        method="xml"
        omit-xml-declaration="yes"
        encoding="UTF-8"
        indent="yes" />

    <xsl:template match="/">
                        
        <xsl:apply-templates select="message" />

        <form class="form-horizontal" method="POST" action="/">
            <fieldset>
                <hr/>
                <div class="control-group">
                    <label class="control-label" for="login">Логин</label>
                    <div class="controls">
                        <input type="text" class="input-xlarge" id="login" name="login" />
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label" for="password">Пароль</label>
                    <div class="controls">
                        <input type="password" class="input-xlarge" id="password" name="password" />
                    </div>
                </div>

                <div class="form-actions">
                    <button class="btn btn-large btn-inverse" type="submit">Войти</button>
                    <!--<button class="btn btn-large">Вспомнить пароль</button>-->
                </div>

            </fieldset>
        </form>
                        
    </xsl:template>

    <!-- messages -->

    <xsl:template match="message">
        <div class="alert alert-{@type}">
            <xsl:apply-templates />
        </div>
    </xsl:template>

</xsl:stylesheet>
