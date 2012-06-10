<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
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
        
    <xsl:template match="/">
        
        <xsl:apply-templates select="Person"/>
        
    </xsl:template>
    
    <xsl:template match="Person">
        <html>
            <head>
                <meta charset="utf-8" />
                <title>Администрирование</title>
                <link href="/media/templates/default/css/bootstrap.min.css" rel="stylesheet" />
                <link href="/media/styles.css" rel="stylesheet" />
                <xsl:comment>Le HTML5 shim, for IE6-8 support of HTML5 elements</xsl:comment>
                <xsl:comment><![CDATA[[if lt IE 9]><script src="/media/js/html5.js"></script><![endif]]]></xsl:comment>
            </head>
            <body>
                
                <div class="navbar navbar-fixed-top">
                    <div class="navbar-inner">
                    <div class="container">
                        <a class="brand" href="/">Diploma</a>
                    </div>
                    </div>
                </div>
                               
                <div class="container">
                    <div class="row">
                        
                    <!--<div class="span3"></div>-->
                        
                    <div class="offset3 span9">
                    <!-- Messages -->

                    <xsl:apply-templates select="meta" />

                    <!-- Profile -->

                    <form class="form-horizontal" method="POST" action="/signup">
                        <fieldset>
                        <legend>Регистрация</legend>

                            <xsl:apply-templates select="." mode="last_name" />
                            <xsl:apply-templates select="." mode="first_name" />
                            <xsl:apply-templates select="." mode="middle_name" />

                            <hr />
                            
                            <xsl:apply-templates select="." mode="sid" />
                            
                            <hr />

                            <xsl:apply-templates select="." mode="login" />
                            <xsl:apply-templates select="." mode="password" />

                            <hr />

                            <div class="control-group">
                                <label for="cellphone" class="control-label">Мобильный телефон</label>
                                <div class="controls">
                                    <input type="text" name="cellphone" id="cellphone" class="input-xlarge">
                                        <xsl:attribute name="value">
                                            <xsl:apply-templates select="cellphone"/>
                                        </xsl:attribute>
                                    </input>
                                        <p class="help-block">
                                            <small>Укажите настоящий мобильный телефон без плюса.
                                                <br/>Например, <strong>79119010203.</strong></small>
                                        </p>
                                    </div>
                            </div>

                            <div class="form-actions">
                                <button class="btn btn btn-inverse" type="submit">Зарегистрироваться</button>
                            </div>

                        </fieldset>
                    </form>
                    
                    </div>
                        
                    </div>                   
                </div>
                
                <script src="/media/js/jquery.min.js">
                    <xsl:text><![CDATA[]]></xsl:text>
                </script>
                
            </body>
        </html>
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
    
    <!-- Login -->
    
    <xsl:template mode="login" match="Person">
        <xsl:call-template name="input">
            <xsl:with-param name="id" select="'login'" />
            <xsl:with-param name="title" select="'Логин'" />
        </xsl:call-template>
    </xsl:template>
    
    <!-- Password -->
      
    <xsl:template mode="password" match="Person">
        <xsl:call-template name="input">
            <xsl:with-param name="id" select="'password'" />
            <xsl:with-param name="title" select="'Пароль'" />
        </xsl:call-template>
    </xsl:template>   
    
    <!-- SID -->
      
    <xsl:template mode="sid" match="Person">
        <xsl:call-template name="input">
            <xsl:with-param name="id" select="'sid'" />
            <xsl:with-param name="title" select="'Номер документа'" />
        </xsl:call-template>
    </xsl:template>   
    

</xsl:stylesheet>
