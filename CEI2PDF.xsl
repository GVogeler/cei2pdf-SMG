<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xrx="http://www.monasterium.net/NS/xrx" xmlns:cei="http://www.monasterium.net/NS/cei"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:atom="http://www.w3.org/2005/Atom"
    version="3.0" id="charter2pdf">
    <xsl:preserve-space elements="*"/>
    <xsl:output indent="yes"/>


    <xsl:key name="names" match="//*" use="local-name(.)"/>
    <xsl:param name="input" select="base-uri(.)"/>
    
    

    <!-- function cei:prepare_ext -->
    <xsl:function name="cei:prepare_ext">
        <xsl:param name="input"/>
        <xsl:param name="vorfahren"/>
        <xsl:choose>
            <xsl:when test="$vorfahren/@rend[contains(., 'monogrammat') or contains(., 'maiusc') or contains(., 'elongat') or contains(., 'capital') or contains(., 'oncia')]">
                
                
                <!--  <xsl:value-of select="$vorfahren/*/name()"/> cei:hi[contains(@rend, 'monogrammat') or contains(@rend, 'maiusc') or contains(@rend, 'elongat') or contains(@rend, 'capital') or contains(@rend, 'oncia')] -->
                <xsl:analyze-string select="$input" regex="[A-Z]">
                    <xsl:matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        
                        <fo:inline font-style="normal" font-size="75%">
                            <xsl:value-of select="(upper-case(.))"/>
                        </fo:inline>
                        
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                    select="
                        replace(replace($input, '&quot;',
                        '”'), '”(\w)', '“$1')"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- function cei:prepare -->
    <xsl:function name="cei:prepare">
        <xsl:param name="input"/>
        <xsl:value-of select="replace(replace($input, '&quot;', '”'), '”(\w)', '“$1')"/>
    </xsl:function>


    <!-- Leerzeichen aus Elementen rausziehen (löschen und zwischen Elemente schreiben) -->
    <!-- Input Urkunden // XML-Dateien -->
    <xsl:variable name="intermediate1"
        select="replace(unparsed-text($input), '([\S]) ((&lt;/[^>]*?>)+)', '$1$2 ')"/>
    <xsl:variable name="intermediate2"
        select="replace($intermediate1, ' (&lt;cei:note.*?&lt;/cei:note>)', '$1 ')"/>
    <xsl:variable name="result"
        select="parse-xml(replace($intermediate2, ' (&lt;cei:handShift.*?/>)', '$1 '))"/>


    <!-- Wurzelknoten -->
    <xsl:template match="/">
        <!-- <xsl:result-document href="replaced1.xml">
            <xsl:copy-of select="$result"/>
        </xsl:result-document>-->
        <xsl:call-template name="charter">
            <xsl:with-param name="Funktion1"> </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="charter">
        <xsl:param name="Funktion1"/>
        <fo:root>

            <!-- Seitenlayout/Seitenzahlen/Überschrift -->
            <fo:layout-master-set>

                <fo:simple-page-master master-name="rechts" margin-top="2cm" margin-bottom="2cm"
                    margin-left="2cm" margin-right="2cm">
                    <fo:region-body margin-top="10mm"/>
                    <fo:region-before extent="20mm" region-name="kopf-rechte-seiten"/>
                    <fo:region-after/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="links" margin-top="2cm" margin-bottom="2cm"
                    margin-left="2cm" margin-right="2cm">
                    <fo:region-body margin-top="10mm"/>
                    <fo:region-before extent="20mm" region-name="kopf-linke-seiten"/>
                    <fo:region-after/>
                </fo:simple-page-master>

                <fo:page-sequence-master master-name="seitenfolgen">
                    <fo:repeatable-page-master-alternatives>
                        <fo:conditional-page-master-reference master-reference="links"
                            odd-or-even="odd"/>
                        <fo:conditional-page-master-reference master-reference="rechts"
                            odd-or-even="even"/>
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>

            </fo:layout-master-set>

            <fo:page-sequence master-reference="seitenfolgen" font-family="Times New Roman">

                <fo:static-content flow-name="kopf-rechte-seiten">
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-column column-width="100mm"/>
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell column-number="2">
                                    <fo:block text-align="center">Documenti</fo:block>
                                </fo:table-cell>
                                <fo:table-cell column-number="3">
                                    <fo:block text-align="right">
                                        <fo:page-number/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>

                <fo:static-content flow-name="kopf-linke-seiten">
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-column column-width="100mm"/>
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell column-number="2">
                                    <fo:block text-align="center">Documenti</fo:block>
                                </fo:table-cell>
                                <fo:table-cell column-number="1">
                                    <fo:block text-align="left">
                                        <fo:page-number/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>
                <xsl:document/>
                <fo:static-content flow-name="xsl-footnote-separator">
                    <fo:block text-indent="0mm" space-before="0mm"> </fo:block>
                </fo:static-content>

                <fo:flow flow-name="xsl-region-body">

                    <!-- Input Urkunden aus Variable -->

                    <xsl:for-each select="$result//atom:entry">

                        <!-- Variable für Fußnotenkörper-->
                        <xsl:variable name="footnote">

                            <!-- Buchstaben -->
                            <fo:block line-height-shift-adjustment="disregard-shifts"
                                line-height="1.5em" space-after="5mm">

                                <xsl:for-each
                                    select="
                                        .//cei:tenor//cei:add[@hand and not(@type)] |
                                        .//cei:tenor//cei:add[@type and not(@hand)] |
                                        .//cei:tenor//cei:add[@type and @hand] |
                                        .//cei:tenor//cei:c[@type] |
                                        .//cei:tenor//cei:corr[@type and @sic] |
                                        .//cei:tenor//cei:corr[@type and not(@sic)] |
                                        .//cei:tenor//cei:corr[not(@type) and @sic] |
                                        .//cei:tenor//cei:damage[attribute()] |
                                        .//cei:tenor//cei:del[@type] |
                                        .//cei:tenor//cei:handShift[@hand] |
                                        .//cei:tenor//cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))] |
                                        .//cei:tenor//cei:sic[@corr or not(attribute())] |
                                        .//cei:tenor//cei:space |
                                        .//cei:tenor//cei:supplied[@type] |
                                        .//cei:tenor//cei:unclear[@reason]
                                        ">

                                    <fo:inline baseline-shift="super" font-size="8pt">
                                        <xsl:number value="position()" format="a"/>
                                    </fo:inline>
                                    <xsl:text>&#xa0;</xsl:text>

                                    <!-- cei:add[@hand] -->
                                    <xsl:if test="self::cei:add[@hand and not(@type)]">
                                        <xsl:apply-templates select="* | text()"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:analyze-string select="@hand" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:add[@type] -->
                                    <xsl:if test="self::cei:add[@type and not(@hand)]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:add[@type] -->
                                    <xsl:if test="self::cei:add[@type and @hand]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                        <xsl:analyze-string select="@hand" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:c[@type] -->
                                    <xsl:if test="self::cei:c[@type]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:corr[@type and @sic] -->
                                    <xsl:if test="self::cei:corr[@type and @sic]">
                                        <xsl:choose>
                                            <!-- Attribut @type überprüfen: wenn "su"  -->
                                            <xsl:when test="@type = 'su'">
                                                <!-- Achtung: Matched nur auf einen Text-Knoten -->
                                                <xsl:if
                                                  test="ends-with(text()[last()]/preceding::text()[1], ' ') and starts-with(text()/following::text()[1], ' ')">
                                                  <xsl:value-of select="text()"/>
                                                </xsl:if>
                                                <xsl:if
                                                  test="not(ends-with(text()[1]/preceding::text()[1], ' ')) and starts-with(text()[1]/following::text()[1], ' ')">
                                                  <xsl:value-of select="concat('-', text()[1])"/>
                                                </xsl:if>
                                                <xsl:if
                                                  test="ends-with(text()[last()]/preceding::text()[1], ' ') and not(starts-with(text()/following::text()[1], ' '))">
                                                  <xsl:value-of select="concat(text()[1], '-')"/>
                                                </xsl:if>
                                                <xsl:if
                                                  test="not(ends-with(text()[last()]/preceding::text()[1], ' ')) and not(starts-with(text()[1]/following::text()[1], ' '))">
                                                  <xsl:value-of select="concat('-', text()[1], '-')"
                                                  />
                                                </xsl:if>
                                                <fo:inline font-style="italic">
                                                  <xsl:text> corr. su </xsl:text>
                                                </fo:inline>
                                                <xsl:analyze-string select="@sic"
                                                  regex="/\w?[^/]*\w?/">
                                                  <xsl:matching-substring>
                                                  <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                  </fo:inline>
                                                  </xsl:matching-substring>
                                                  <xsl:non-matching-substring>
                                                  <xsl:value-of select="."/>
                                                  </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat('-', text()[1], '-')"/>
                                                <fo:inline font-style="italic">
                                                  <xsl:text> corr. da </xsl:text>
                                                </fo:inline>
                                                <xsl:analyze-string select="@sic"
                                                  regex="/\w?[^/]*\w?/">
                                                  <xsl:matching-substring>
                                                  <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                  </fo:inline>
                                                  </xsl:matching-substring>
                                                  <xsl:non-matching-substring>
                                                  <xsl:value-of select="."/>
                                                  </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                                <xsl:text>, </xsl:text>
                                                <xsl:analyze-string select="@type"
                                                  regex="/\w?[^/]*\w?/">
                                                  <xsl:matching-substring>
                                                  <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                  </fo:inline>
                                                  </xsl:matching-substring>
                                                  <xsl:non-matching-substring>
                                                  <xsl:value-of select="."/>
                                                  </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>

                                    <!-- cei:corr[@type and not(@sic)] -->
                                    <xsl:if test="self::cei:corr[@type and not(@sic)]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:corr[not(@type) and @sic] -->
                                    <xsl:if test="self::cei:corr[not(@type) and @sic]">
                                        <xsl:choose>
                                            <xsl:when
                                                test="starts-with(@sic, 'A ') or starts-with(@sic, 'B ') or starts-with(@sic, 'B'' ')">
                                                <xsl:value-of select="@sic"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <!-- Achtung: Matched jetzt nur auf einen Text-Knoten -->
                                                <xsl:if
                                                  test="ends-with(text()[last()]/preceding::text()[1], ' ') and starts-with(text()[1]/following::text()[1], ' ')">
                                                  <xsl:value-of select="text()"/>
                                                </xsl:if>
                                                <xsl:if
                                                  test="not(ends-with(text()[last()]/preceding::text()[1], ' ')) and starts-with(text()[1]/following::text()[1], ' ')">
                                                  <xsl:value-of select="concat('-', text()[1])"/>
                                                </xsl:if>
                                                <xsl:if
                                                  test="ends-with(text()[last()]/preceding::text()[1], ' ') and not(starts-with(text()[1]/following::text()[1], ' '))">
                                                  <xsl:value-of select="concat(text()[1], '-')"/>
                                                </xsl:if>
                                                <xsl:if
                                                  test="not(ends-with(text()[1]/preceding::text()[1], ' ')) and not(starts-with(text()[1]/following::text()[1], ' '))">
                                                  <xsl:value-of select="concat('-', text()[1], '-')"
                                                  />
                                                </xsl:if>
                                                <fo:inline font-style="italic">
                                                  <xsl:text> corr. da</xsl:text>
                                                  <xsl:text> </xsl:text>
                                                </fo:inline>
                                                <xsl:analyze-string select="@sic"
                                                  regex="/\w?[^/]*\w?/">
                                                  <xsl:matching-substring>
                                                  <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                  </fo:inline>
                                                  <xsl:text>&#x200D;</xsl:text>
                                                  </xsl:matching-substring>
                                                  <xsl:non-matching-substring>
                                                  <xsl:value-of select="."/>
                                                  </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>

                                    <!-- cei:damage[@agent and not(@extent)] -->
                                    <xsl:if test="self::cei:damage[@agent and not(@extent)]">
                                        <xsl:analyze-string select="@agent" regex="/\w?[^/]*\w?/">
                                            <!-- beides italic? -->
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of select="."/>
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:damage[not(@agent) and @extent] -->
                                    <xsl:if test="self::cei:damage[not(@agent) and @extent]">
                                        <xsl:text>&#x200D;</xsl:text>
                                        <fo:inline font-style="italic">
                                            <xsl:text>Lacuna</xsl:text>
                                        </fo:inline>
                                        <xsl:analyze-string select="@extent" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of select="."/>
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:damage[@agent) and @extent] -->
                                    <xsl:if test="self::cei:damage[@agent and @extent]">
                                        <xsl:analyze-string select="@agent" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of select="."/>
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                        <xsl:text> </xsl:text>
                                        <xsl:analyze-string select="@extent" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of select="."/>
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:del[@type] -->
                                    <xsl:if test="self::cei:del[@type]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:handShift[@hand] -->
                                    <xsl:if test="self::cei:handShift[@hand]">
                                        <xsl:analyze-string select="@hand" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))] -->
                                    <xsl:if
                                        test="self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))]">
                                        <xsl:apply-templates select="* | text()"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:analyze-string select="@rend" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:sic[@corr] -->
                                    <xsl:if test="self::cei:sic[@corr]">
                                        <xsl:text>&#x200D;</xsl:text>
                                        <fo:inline font-style="italic">
                                            <xsl:text>Così </xsl:text>
                                        </fo:inline>
                                        <xsl:if
                                            test="ancestor::cei:text//cei:witnessOrig/cei:traditioForm[text()]">
                                            <xsl:text>A, </xsl:text>
                                        </xsl:if>
                                        <xsl:if
                                            test="not(ancestor::cei:text//cei:witnessOrig/cei:traditioForm[text()])">
                                            <xsl:value-of
                                                select="concat(ancestor::cei:text//cei:witListPar/cei:witness[1]/@n, ', ')"
                                            />
                                        </xsl:if>
                                        <xsl:analyze-string select="@corr" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:sic[not(attribute())] -->
                                    <xsl:if test="self::cei:sic[not(attribute())]">
                                        <xsl:text>&#x200D;</xsl:text>
                                        <fo:inline font-style="italic">
                                            <xsl:text>Così </xsl:text>
                                        </fo:inline>
                                        <xsl:if
                                            test="ancestor::cei:text//cei:witnessOrig/cei:traditioForm[text()]">
                                            <xsl:text>A.</xsl:text>
                                        </xsl:if>
                                        <xsl:if
                                            test="not(ancestor::cei:text//cei:witnessOrig/cei:traditioForm[text()])">
                                            <xsl:value-of
                                                select="concat(ancestor::cei:text//cei:witListPar/cei:witness[1]/@n, '.')"
                                            />
                                        </xsl:if>
                                    </xsl:if>

                                    <!-- cei:space -->
                                    <xsl:if test="self::cei:space">
                                        <xsl:text>&#x200D;</xsl:text>
                                        <fo:inline font-style="italic">
                                            <xsl:text>Spazio lasciato in bianco </xsl:text>
                                            <xsl:if test="string-length(@extent) != 0">
                                                <xsl:analyze-string select="@extent"
                                                  regex="/\w?[^/]*\w?/">
                                                  <xsl:matching-substring>
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                  </xsl:matching-substring>
                                                  <xsl:non-matching-substring>
                                                  <xsl:value-of select="."/>
                                                  </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:if>
                                        </fo:inline>
                                        <xsl:text>&#x200D;</xsl:text>
                                    </xsl:if>

                                    <!-- cei:supplied[@type] -->
                                    <xsl:if test="self::cei:supplied[@type]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:unclear[@reason] -->
                                    <xsl:if test="self::cei:unclear[@reason]">
                                        <!-- Achtung: Matched nur auf einen Text-Knoten -->
                                        <xsl:if
                                            test="ends-with(text()[last()]/preceding::text()[1], ' ') and starts-with(text()/following::text()[1], ' ')">
                                            <xsl:value-of select="text()"/>
                                        </xsl:if>
                                        <xsl:if
                                            test="not(ends-with(text()[1]/preceding::text()[1], ' ')) and starts-with(text()[1]/following::text()[1], ' ')">
                                            <xsl:value-of select="concat('-', text()[1])"/>
                                        </xsl:if>
                                        <xsl:if
                                            test="ends-with(text()[last()]/preceding::text()[1], ' ') and not(starts-with(text()/following::text()[1], ' '))">
                                            <xsl:value-of select="concat(text()[1], '-')"/>
                                        </xsl:if>
                                        <xsl:if
                                            test="not(ends-with(text()[last()]/preceding::text()[1], ' ')) and not(starts-with(text()[1]/following::text()[1], ' '))">
                                            <xsl:value-of select="concat('-', text()[1], '-')"/>
                                        </xsl:if>
                                        <xsl:text> </xsl:text>
                                        <xsl:analyze-string select="@reason" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- Abstand zwischen Fußnoten -->
                                    <xsl:text xml:space="preserve">    </xsl:text>
                                </xsl:for-each>
                            </fo:block>

                            <!-- Zahlen -->
                            <fo:block line-height-shift-adjustment="disregard-shifts"
                                line-height="1.5em" space-after="5mm">

                                <xsl:for-each
                                    select="
                                        .//cei:tenor//cei:bibl[ancestor::cei:cit] |
                                        .//cei:tenor//cei:note">

                                    <fo:inline baseline-shift="super" font-size="8pt">
                                        <xsl:number value="position()"/>
                                    </fo:inline>
                                    <xsl:text>&#xa0;</xsl:text>

                                    <!-- cei:bibl[ancestor::cei:cit] -->
                                    <xsl:if test="self::cei:bibl[ancestor::cei:cit]">
                                        <xsl:analyze-string select="." regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <xsl:text>&#x200D;</xsl:text>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                                <xsl:text>&#x200D;</xsl:text>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                        <xsl:if
                                            test="not(ends-with(normalize-space(.), '.')) and not(ends-with(normalize-space(.), './'))">
                                            <xsl:text>.</xsl:text>
                                        </xsl:if>
                                    </xsl:if>

                                    <!-- cei:note -->
                                    <xsl:if test="self::cei:note">
                                        <xsl:apply-templates select="* | text()"/>
                                        <xsl:if
                                            test="not(ends-with(normalize-space(.), '.')) and not(ends-with(normalize-space(.), './'))">
                                            <xsl:text>.</xsl:text>
                                        </xsl:if>
                                    </xsl:if>

                                    <!-- Abstand zwischen Fußnoten -->
                                    <xsl:text xml:space="preserve">    </xsl:text>
                                </xsl:for-each>
                            </fo:block>

                        </xsl:variable>

                        <!-- Ausgabe Urkundennummer -->
                        <fo:block text-align="center" space-before="20mm" space-after="0mm"
                            keep-with-next.within-page="always" font-weight="bold">
                            <xsl:number value="position()" format="1"/>
                        </fo:block>

                        <!-- Ausgabe Urkunde -->
                        <xsl:call-template name="issued"/>
                        <xsl:call-template name="abstract"/>
                        <xsl:call-template name="wittnes"/>
                        <xsl:call-template name="edition"/>
                        <xsl:call-template name="facsimile"/>
                        <xsl:call-template name="regest"/>
                        <xsl:call-template name="physicalDesc"/>
                        <xsl:call-template name="misura"/>
                        <xsl:call-template name="link"/>
                        <fo:block space-after="5mm"/>
                        <xsl:call-template name="tenor"/>

                        <!-- Absatz zwischen Urkunde und Fußnoten -->
                        <fo:block space-after="10mm"/>

                        <!-- Ausgabe Variable Fußnotenkörper -->
                        <fo:block text-indent="0mm" text-align="justify">
                            <xsl:copy-of select="$footnote"/>
                        </fo:block>

                    </xsl:for-each>

                </fo:flow>
            </fo:page-sequence>
        </fo:root>

    </xsl:template>

    <!-- Templates Metadaten-->

    <!-- Template "issued" (Datum und Ort der Urkunde) -->
    <xsl:template name="issued">
        <xsl:if test=".//cei:issued">
            <fo:block text-align="center" keep-with-next.within-page="always">

                <!-- Datum -->
                <xsl:apply-templates
                    select=".//cei:issued/cei:date/text() | .//cei:issued/cei:dateRange/text()"
                    mode="normalized"/>

                <!-- Test auf Vorkommen von Datum und Ort -->
                <xsl:if
                    test=".//cei:issued/cei:date/text() and .//cei:issued/cei:placeName/text() or .//cei:issued/cei:dateRange/text() and .//cei:issued/cei:placeName/text()">
                    <xsl:text>, </xsl:text>
                </xsl:if>

                <!-- Ort -->
                <xsl:apply-templates select=".//cei:issued/cei:placeName"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "abstract" (Zusammenafssung der Urkunde) -->
    <xsl:template name="abstract">
        <xsl:if test=".//cei:abstract">
            <fo:block text-align="justify" text-indent="10mm">
                <xsl:apply-templates
                    select=".//cei:abstract/text() | .//cei:abstract//cei:foreign | .//cei:abstract//cei:quote"
                />
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "wittness" (Quelle der Urkunde) -->
    <xsl:template name="wittnes">


        <fo:block text-indent="10mm" text-align="justify" margin-top="5mm" font-size="10pt">
            <!-- Fall 1: Die Urkunde ist ein Original -->
            <xsl:if test=".//cei:witnessOrig/cei:traditioForm/text()">
                <!-- Originale -->
                <xsl:value-of select="normalize-space(.//cei:witnessOrig/cei:traditioForm/text())"/>
                <xsl:text>, </xsl:text>
                <!-- <cei:arch -->
                <xsl:if test=".//cei:witnessOrig/cei:archIdentifier/cei:arch/text()">
                    <xsl:value-of
                        select="normalize-space(.//cei:witnessOrig/cei:archIdentifier/cei:arch[1]/text())"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <!-- <cei:idno> -->
                <xsl:if test=".//cei:witnessOrig/cei:archIdentifier/cei:idno/text()">
                    <xsl:value-of
                        select="normalize-space(.//cei:witnessOrig/cei:archIdentifier/cei:idno[1]/text())"
                    />
                </xsl:if>
                <!-- Sigle A -->
                <xsl:if test=".//cei:witnessOrig/cei:traditioForm/text()">
                    <xsl:text> [A]</xsl:text>
                </xsl:if>
                <xsl:choose>

                    <!-- Fall 1b: Es gibt Kopien -->
                    <xsl:when test=".//cei:witListPar/cei:witness[@n]">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <!-- Fall 1: Es gibt keine Kopien -->
                    <xsl:otherwise>
                        <xsl:text>. </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- Copia -->
                <!-- Ausgabe Kopien -->
                <xsl:if
                    test=".//cei:witListPar/cei:witness[@n]">
                    <xsl:for-each
                        select=".//cei:witListPar/cei:witness[@n]">
                        <xsl:value-of select=".//cei:traditioForm"/>
                        <xsl:text>, </xsl:text>
                        <!-- <cei:arch -->
                        <xsl:if test="ancestor::cei:text//cei:arch/text()">
                            <xsl:value-of
                                select="normalize-space(cei:archIdentifier/cei:arch/text())"/>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <!-- <cei:idno> -->
                        <xsl:if test="ancestor::cei:text//cei:idno/text()">
                            <xsl:value-of
                                select="normalize-space(cei:archIdentifier/cei:idno/text())"/>
                        </xsl:if>
                        <xsl:if test=".[@n]">
                            <xsl:value-of select="concat(' [', @n, ']')"/>
                        </xsl:if>
                        <xsl:if test="cei:archIdentifier/text()[preceding-sibling::cei:idno]">
                            <xsl:value-of select="concat('', cei:archIdentifier/text()[last()])"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>. </xsl:text>
                </xsl:if>
            </xsl:if>
            <!-- Fall 2: Die Urkunde ist eine beglaubigte Kopie -->
            <xsl:if test="not(.//cei:witnessOrig/cei:traditioForm/text())">
                <!-- Copia autentica -->
                <xsl:value-of
                    select="normalize-space(.//cei:witListPar/cei:witness[1]//cei:traditioForm/text())"/>
                <xsl:text>, </xsl:text>
                <!-- <cei:arch -->
                <xsl:if test=".//cei:witListPar/cei:witness[1]//cei:arch/text()">
                    <xsl:value-of
                        select="normalize-space(.//cei:witListPar/cei:witness[1]//cei:arch/text())"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <!-- <cei:idno> -->
                <xsl:if test=".//cei:witListPar/cei:witness[1]//cei:idno/text()">
                    <xsl:value-of
                        select="normalize-space(.//cei:witListPar/cei:witness[1]//cei:idno/text())"
                    />
                </xsl:if>
                <!-- Sigle B -->
                <xsl:if test=".//cei:witListPar/cei:witness[1][@n]">
                    <xsl:value-of select="concat(' [', .//cei:witListPar/cei:witness[1]/@n, ']')"/>
                </xsl:if>
                <xsl:choose>
                    <!-- Fall 2b: Es gibt Kopien -->
                    <xsl:when test=".//cei:witListPar/cei:witness[2]">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>. </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- Copia -->
                <xsl:if
                    test=".//cei:witListPar/cei:witness[not(position() = 1)][cei:traditioForm[text()]]">
                    <xsl:for-each
                        select=".//cei:witListPar/cei:witness[not(position() = 1)][cei:traditioForm[text()]]">
                        <xsl:value-of select=".//cei:traditioForm"/>
                        <xsl:text>, </xsl:text>
                        <!-- <cei:arch -->
                        <xsl:if test="ancestor::cei:text//cei:arch/text()">
                            <xsl:value-of
                                select="normalize-space(cei:archIdentifier/cei:arch/text())"/>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <!-- <cei:idno> -->
                        <xsl:if test="ancestor::cei:text//cei:idno/text()">
                            <xsl:value-of
                                select="normalize-space(cei:archIdentifier/cei:idno/text())"/>
                        </xsl:if>
                        <xsl:if test=".[@n]">
                            <xsl:value-of select="concat(' [', @n, ']')"/>
                        </xsl:if>
                        <xsl:if test="cei:archIdentifier/text()[preceding-sibling::cei:idno]">
                            <xsl:value-of select="concat(' ', cei:archIdentifier/text()[last()])"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>. </xsl:text>
                </xsl:if>
            </xsl:if>

            <!-- Achtung: Datum ausgeben. Steht am Ende von archidentifier -->

            <!-- cei:rubrum -->
            <xsl:apply-templates select=".//cei:witnessOrig/cei:rubrum"/>

            <!-- cei:nota -->
            <xsl:apply-templates select=".//cei:witnessOrig/cei:nota"/>

        </fo:block>
    </xsl:template>

    <!-- Template "edition" (Edition) -->
    <xsl:template name="edition">
        <!-- Problem, es werden Leerzeichen produziert -->
        <xsl:if test=".//cei:diplomaticAnalysis/cei:listBiblEdition/cei:bibl/text()">
            <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
                <xsl:text>Ed. </xsl:text>
                <xsl:apply-templates select=".//cei:diplomaticAnalysis/cei:listBiblEdition/cei:bibl"/>
                <!-- Link auf Monasterium-Seite einfügen: http://monasterium.net/mom/smg-EV/SMG_2_AA_I_5/charter -->
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "facsimile" -->
    <xsl:template name="facsimile">
        <xsl:if test=".//cei:diplomaticAnalysis/cei:listBiblFaksimile/cei:bibl/text()">
            <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
                <xsl:text>Facs. </xsl:text>
                <xsl:apply-templates
                    select=".//cei:diplomaticAnalysis/cei:listBiblFaksimile/cei:bibl"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "regest" -->
    <xsl:template name="regest">
        <xsl:if test=".//cei:diplomaticAnalysis/cei:listBiblRegest/cei:bibl/text()">
            <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
                <xsl:text>Reg. </xsl:text>
                <xsl:apply-templates select=".//cei:diplomaticAnalysis/cei:listBiblRegest/cei:bibl"
                />
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "physicalDesc" -->
    <xsl:template name="physicalDesc">
        <xsl:if test=".//cei:witnessOrig/cei:physicalDesc//text()">
            <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
                <xsl:apply-templates
                    select=".//cei:witnessOrig/cei:physicalDesc/cei:condition/text()"
                    mode="normalized"/>
                <xsl:text> </xsl:text>
                <xsl:apply-templates
                    select=".//cei:witnessOrig/cei:physicalDesc/cei:material/text()"
                    mode="normalized"/>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select=".//cei:witnessOrig/cei:auth/cei:sealDesc/text()"
                    mode="normalized"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "misura" -->
    <xsl:template name="misura">
        <xsl:if test=".//cei:witnessOrig/cei:physicalDesc/cei:dimensions/text()">
            <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
                <xsl:text>Misura </xsl:text>
                <xsl:apply-templates
                    select=".//cei:witnessOrig/cei:physicalDesc/cei:dimensions/text()"/>
                <xsl:text>. </xsl:text>
                <xsl:apply-templates select=".//cei:p[(position() = 1)]" mode="erstes"/>
            </fo:block>
            <xsl:apply-templates select=".//cei:p[not(position() = 1)]" mode="mittlere"
            > </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <!-- Template "link" -->
    <xsl:template name="link">
        <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
            <xsl:text>Edizione digitale dei documenti dell'abbazia di S. Maria della Grotta presso Benevento (1200- 1250), n. ## (</xsl:text>
            <xsl:text>http://monasterium.net/mom/SMG1200-1250/SMG', '_##', '/charter</xsl:text>
            <xsl:value-of select="concat(')', '')"/>
        </fo:block>

    </xsl:template>


    <!-- Templates Metadaten/Fußnoten Ausgabe Text  -->

    <!-- text() -->
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>

    <!-- cei:author-->
    <xsl:template match="cei:author">
        <xsl:choose>
            <xsl:when test="cei:persName">
                <xsl:if test="cei:persName/cei:forename">
                    <xsl:text> </xsl:text>
                    <xsl:analyze-string select="." regex="[A-Z]">
                        <xsl:matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <fo:inline font-style="normal" font-size="75%">
                                <xsl:value-of select="upper-case(.)"/>
                            </fo:inline>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:if>
                <xsl:if test="cei:persName/cei:surname">
                    <xsl:text> </xsl:text>
                    <xsl:analyze-string select="." regex="[A-Z]">
                        <xsl:matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <fo:inline font-style="normal" font-size="75%">
                                <xsl:value-of select="upper-case(.)"/>
                            </fo:inline>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> </xsl:text>
                <xsl:for-each select="text()">
                    <xsl:analyze-string select="." regex="[A-Z]">
                        <xsl:matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <fo:inline font-style="normal" font-size="75%">
                                <xsl:value-of select="upper-case(.)"/>
                            </fo:inline>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- cei:bibl -->
    <xsl:template match="cei:bibl">
        <xsl:apply-templates select="* | text()"/>
    </xsl:template>

    <!-- cei:expan -->
    <xsl:template match="cei:expan">
        <xsl:text>(</xsl:text>
        <xsl:apply-templates select="* | text()"/>
        <xsl:text>)</xsl:text>
    </xsl:template>

    <!-- cei:foreign -->
    <xsl:template match="cei:foreign">
        <fo:inline font-style="italic">
            <xsl:apply-templates select="* | text()"/>
        </fo:inline>
    </xsl:template>

    <!-- cei:quote -->
    <xsl:template match="cei:quote">
        <fo:inline font-style="italic">
            <xsl:apply-templates select="* | text()"/>
        </fo:inline>
    </xsl:template>

    <!-- cei:nota -->
    <xsl:template match="cei:nota">
        <xsl:apply-templates select="* | text()"/>
    </xsl:template>

    <!-- cei:p (erstes) -->
    <xsl:template match="cei:p" mode="erstes">
        <xsl:apply-templates select="* | text()"/>
    </xsl:template>

    <!-- cei:p (mittlere) -->
    <xsl:template match="cei:p" mode="mittlere">
        <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
            <xsl:apply-templates select="* | text()"/>
        </fo:block>
    </xsl:template>

    <!-- cei:p (letztes) -->
    <xsl:template match="cei:p" mode="letztes">
        <fo:block text-indent="10mm" text-align="justify" font-size="10pt" margin-top="2.5mm"
            margin-bottom="2.5mm">
            <xsl:apply-templates select="* | text()"/>
        </fo:block>
    </xsl:template>

    <!-- cei:rubrum -->
    <xsl:template match="cei:rubrum">
        <xsl:apply-templates select="* | text()"/>
    </xsl:template>

    <!-- cei:title -->
    <xsl:template match="cei:title">
        <fo:inline font-style="italic">
            <xsl:apply-templates select="* | text()"/>
        </fo:inline>
    </xsl:template>

    <!-- Template "tenor" -->
    <xsl:template name="tenor">
        <xsl:apply-templates select=".//cei:pTenor"/>
    </xsl:template>


    <!-- Templates Tenor -->

    <!-- Templates aufrufen für cei:pTenor -->
    <xsl:template match="cei:pTenor">
        <xsl:if test="ancestor::cei:text//cei:tenor/cei:pTenor/text()">
            <fo:block text-indent="10mm" text-align="justify" margin-top="0mm"
                line-height-shift-adjustment="disregard-shifts" line-height="1.5em">
                <xsl:apply-templates select="* | text()" mode="tenor"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Durchreichelemente, die keine Behandlung benötigen -->
    <xsl:template
        match="cei:arenga | cei:corroboratio | cei:datatio | cei:dispositio | cei:inscriptio | cei:invocatio | cei:narratio | cei:notariusSub | cei:sanctio | cei:setPhrase | cei:subscriptio">
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>

    <!-- Templates Tenor Ausgabe Text -->

    <!-- text() (tenor) -->
    <xsl:template match="text()" mode="tenor" priority="-1">
        <xsl:choose>
            <!-- Ausgabe Textknoten, die an Fußnotenelement kleben-->
            <xsl:when
                test="
                    not(starts-with(., ' '))
                    and (
                    preceding-sibling::node()[1][self::cei:add[@hand]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:add[@hand]]]
                    or preceding-sibling::node()[1][self::cei:add[@type]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:add[@type]]]
                    or preceding-sibling::node()[1][self::cei:c[@type]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:c[@type]]]
                    or preceding-sibling::node()[1][self::cei:corr[@sic and @type]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:corr[@sic and @type]]]
                    or preceding-sibling::node()[1][self::cei:corr[@sic and not(@type)]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:corr[@sic and not(@type)]]]
                    or preceding-sibling::node()[1][self::cei:corr[not(@sic) and @type]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:corr[not(@sic) and @type]]]
                    or preceding-sibling::node()[1][self::cei:damage[attribute()]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:damage[attribute()]]]
                    or preceding-sibling::node()[1][self::cei:del[@type]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:damage[attribute()]]]
                    or preceding-sibling::node()[1][self::cei:handShift[@hand]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:handShift[@hand]]]
                    or preceding-sibling::node()[1][self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))]]]
                    or preceding-sibling::node()[1][self::cei:sic[@corr or not(attribute())]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:sic[@corr or not(attribute())]]]
                    or preceding-sibling::node()[1][self::cei:space] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:space]]
                    or preceding-sibling::node()[1][self::cei:supplied[@type]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:supplied[@type]]]
                    or preceding-sibling::node()[1][self::cei:unclear[@reason]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:unclear[@reason]]]
                    or preceding-sibling::node()[1][self::cei:note] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:note]]
                    or preceding-sibling::node()[1][self::cei:quote[ancestor::cei:cit]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:quote[ancestor::cei:cit]]]
                    )
                    ">

                <xsl:choose>

                    <!-- Der Textknoten hat ein Leerzeichen -->
                    <xsl:when test="contains(., ' ')">
                        <xsl:choose>
                            <!-- Komma (,) vor Leerzeichen -->
                            <xsl:when test="ends-with(substring-before(cei:prepare(.), ' '), ',')">
                                <xsl:text>, </xsl:text>
                                <xsl:copy-of
                                    select="cei:prepare_ext(substring-after(cei:prepare(.), ' '), ./ancestor::*)"
                                />
                            </xsl:when>
                            <!-- Punkt (.) vor Leerzeichen -->
                            <xsl:when test="ends-with(substring-before(cei:prepare(.), ' '), '.')">
                                <xsl:text>. </xsl:text>
                                <xsl:copy-of
                                    select="cei:prepare_ext(substring-after(cei:prepare(.), ' '), ./ancestor::*)"
                                />
                            </xsl:when>
                            <!-- Doppelpunkt (:) vor Leerzeichen -->
                            <xsl:when test="ends-with(substring-before(cei:prepare(.), ' '), ':')">
                                <xsl:text>: </xsl:text>
                                <xsl:copy-of
                                    select="cei:prepare_ext(substring-after(cei:prepare(.), ' '), ./ancestor::*)"
                                />
                            </xsl:when>
                            <!-- Semikolon (;) vor Leerzeichen -->
                            <xsl:when test="ends-with(substring-before(cei:prepare(.), ' '), ';')">
                                <xsl:text>; </xsl:text>
                                <xsl:copy-of
                                    select="cei:prepare_ext(substring-after(cei:prepare(.), ' '), ./ancestor::*)"
                                />
                            </xsl:when>
                            <!-- otherwise -->
                            <xsl:otherwise>
                                <xsl:text> </xsl:text>
                                <xsl:copy-of
                                    select="cei:prepare_ext(substring-after(cei:prepare(.), ' '), ./ancestor::*)"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>

                    <!-- Der Textknoten hat kein Leerzeichen -->
                    <xsl:when test="not(contains(., ' '))">
                        <xsl:choose>
                            <!-- endet mit Komma (,) -->
                            <xsl:when test="ends-with(., ',')">
                                <xsl:text>,</xsl:text>
                            </xsl:when>
                            <!-- endet mit Punkt (.) -->
                            <xsl:when test="ends-with(., '.')">
                                <xsl:text>.</xsl:text>
                            </xsl:when>
                            <!-- endet mit Doppelpunkt (:) -->
                            <xsl:when test="ends-with(., ':')">
                                <xsl:text>:</xsl:text>
                            </xsl:when>
                            <!-- endet mit Semikolon (;) -->
                            <xsl:when test="ends-with(., ';')">
                                <xsl:text>;</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:choose>
                            <!-- Ausgabe Textknoten, die Teil eines Zitates (cei:quote) sind -->
                            <xsl:when test="ancestor::cei:quote">
                                <xsl:text xml:space="preserve"> </xsl:text>
                                <xsl:copy-of
                                    select="cei:prepare_ext(substring-after(cei:prepare(.), ' '), ./ancestor::*)"
                                />
                            </xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <!-- Ausgabe Textknoten, die nicht an Fußnotenelement kleben -->
            <xsl:otherwise>
                <xsl:choose>

                    <!-- Ausgabe Textknoten, die Teil eines Zitates (cei:quote) sind -->
                    <xsl:when test="starts-with(., ' ') and ancestor::cei:quote">
                        <xsl:text xml:space="preserve"> </xsl:text>
                        <xsl:copy-of
                            select="cei:prepare_ext(substring-after(cei:prepare(.), ' '), ./ancestor::*)"
                        />
                    </xsl:when>

                    <!-- otherwise  -->
                    <xsl:otherwise>
                        <xsl:copy-of select="cei:prepare_ext(cei:prepare(.), ./ancestor::*)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- Templates Tenor Ausgabe Text von Elementen, die nicht an Fußbnotenelementen kleben -->

    <!-- cei:bibl (tenor) -->
    <xsl:template match="cei:bibl" mode="tenor" priority="-1"/>

    <!-- cei:cit (tenor) -->
    <xsl:template match="cei:cit" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
        </xsl:if>
    </xsl:template>

    <!-- cei:damage[not(attribute())] (tenor) -->
    <xsl:template match="cei:damage[not(attribute())]" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])">
            <xsl:text>[</xsl:text>
            <xsl:apply-templates select="* | text()" mode="tenor"/>
            <xsl:text>]</xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- cei:expan (tenor) -->
    <xsl:template match="cei:expan" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])">
            <xsl:choose>
                <xsl:when test="contains(./text()[1], 'Iesu')">
                    <xsl:apply-templates select="* | text()" mode="tenor"/>
                    <xsl:if test="ends-with(./text()[last()], ' ')">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>(</xsl:text>
                    <xsl:apply-templates select="* | text()" mode="tenor"/>
                    <xsl:text>)</xsl:text>
                    <xsl:if test="ends-with(./text()[last()], ' ')">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!-- cei:foreign (tenor) -->
    <xsl:template match="cei:foreign" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
        </xsl:if>
    </xsl:template>

    <!-- cei:hi not(attribute())] (tenor) -->
    <xsl:template match="cei:hi[not(attribute())]" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
        </xsl:if>
    </xsl:template>

    <!-- cei:hi[contains(@rend,'monogrammat') or contains(@rend,'maiusc') or contains(@rend,'elongat') or contains(@rend,'capital') or contains(@rend,'oncia')] (tenor) -->
    <xsl:template
        match="cei:hi[contains(@rend, 'monogrammat') or contains(@rend, 'maiusc') or contains(@rend, 'elongat') or contains(@rend, 'capital') or contains(@rend, 'oncia')]"
        mode="tenor" priority="-2">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])">
            <xsl:apply-templates select="text() | *" mode="tenor"> </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <!-- cei:hi[not(contains(@rend,'monogrammat') or contains(@rend,'maiusc') or contains(@rend,'elongat') or contains(@rend,'capital') or contains(@rend,'oncia'))] (tenor) -->
    <xsl:template
        match="cei:hi[not(contains(@rend, 'monogrammat') or contains(@rend, 'maiusc') or contains(@rend, 'elongat') or contains(@rend, 'capital') or contains(@rend, 'oncia'))]"
        mode="tenor" priority="-2">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])">
            <xsl:apply-templates select="text() | *" mode="tenor"> </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <!-- cei:index (tenor) -->
    <xsl:template match="cei:index" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
        </xsl:if>
    </xsl:template>

    <!-- cei:lb (tenor) -->
    <xsl:template match="cei:lb" mode="tenor" priority="-1">
        
        <xsl:if
            test="
                preceding-sibling::text()[1] and not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ]) or (starts-with(following::text()[1],' '))">
           
            <xsl:choose>
                <xsl:when
                    test="
                        preceding-sibling::node()[1][
                        self::cei:note or
                        self::cei:quote[ancestor::cei:cit] or
                        self::cei:add[@hand] or
                        self::cei:add[@type] or
                        self::cei:c[@type] or
                        self::cei:corr[@sic and @type] or
                        self::cei:corr[@sic and not(@type)] or
                        self::cei:corr[not(@sic) and @type] or
                        self::cei:damage[attribute()] or
                        self::cei:del[@type] or
                        self::cei:handShift[@hand] or
                        self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))] or
                        self::cei:sic[@corr or not(attribute())] or
                        self::cei:space or
                        self::cei:supplied[@type] or
                        self::cei:unclear[@reason]
                        ][not(ends-with(text()[1], ' '))][not(starts-with(following::text()[1],' '))] or (not(preceding-sibling::node() and ancestor::cei:pTenor[1]))">
                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <!-- beides Textknoten; beide Leerzeichen -->
                        <xsl:when
                            test="ends-with(preceding::text()[1], ' ') and starts-with(following::text()[1], ' ')">
                            <xsl:text>|</xsl:text>
                        </xsl:when>
                        <!-- beides Textknoten; erster Leerzeichen, zweiter kein Leerzeichen -->
                        <xsl:when
                            test="ends-with(preceding::text()[1], ' ') and matches(substring(following::text()[1], 1, 1), '\S')">
                            <xsl:text>| </xsl:text>
                        </xsl:when>
                        <!-- beides Textknoten; erster kein Leerzeichen, zweiter Leerzeichen -->
                        <xsl:when
                            test="matches(substring(preceding::text()[1], string-length(preceding::text()[1]), 1), '\S') and starts-with(following::text()[1], ' ')">
                            <xsl:text> |</xsl:text>
                        </xsl:when>
                        <!-- beides Textknoten; erster kein Leerzeichen, zweiter kein Leerzeichen -->
                        <xsl:when
                            test="matches(substring(preceding::text()[1], string-length(preceding::text()[1]), 1), '\S') and matches(substring(following::text()[1], 1, 1), '\S')">
                            <xsl:text>|</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>!!!</xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

    </xsl:template>

    <!-- cei:persName (tenor)-->
    <xsl:template match="cei:persName" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
        </xsl:if>
    </xsl:template>

    <!-- cei:pict (tenor) -->
    <xsl:template match="cei:pict" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])">
            <xsl:if
                test="not(.[@type = 'signum crucis']/ancestor::cei:damage) and .[@type = 'signum crucis']">
                <xsl:text> + </xsl:text>
            </xsl:if>
            <xsl:if test=".[@type = 'signum crucis']/ancestor::cei:damage">
                <xsl:text>+</xsl:text>
            </xsl:if>
            <xsl:if
                test=".[@type = 'signum notarii' or @type = 'signum iudicis' or @type = 'signum testis' or @type = 'signum auctoris']">
                <xsl:text> (S) </xsl:text>
            </xsl:if>
            <xsl:if test=".[@type = 'monogramma']">
                <xsl:text> (M) </xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <!-- cei:quote[not(ancestor::cei:cit)] (tenor) -->
    <xsl:template match="cei:quote[not(ancestor::cei:cit)]" mode="tenor" priority="-1">
        <xsl:if
            test="
                not(preceding-sibling::node()[
                self::cei:note[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:quote[ancestor::cei:cit][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:add[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:c[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[@sic and not(@type)][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:corr[not(@sic) and @type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:damage[attribute()][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:del[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:handShift[@hand][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:sic[@corr or not(attribute())][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:space[not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:supplied[@type][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])] or
                self::cei:unclear[@reason][not(following::text()[following-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]
                ])">
            <xsl:text>&#x200D;</xsl:text>
            <fo:inline font-style="italic">
                <xsl:text>&#x200D;</xsl:text>
                <xsl:apply-templates select="* | text()" mode="tenor"/>
                <xsl:text>&#x200D;</xsl:text>
            </fo:inline>
            <xsl:text>&#x200D;</xsl:text>
        </xsl:if>
    </xsl:template>

    
   
    <!-- Templates Tenor Fußnoten-Elemente -->

    <!-- Zahlen (tenor) -->
    <xsl:template match="
            cei:note |
            cei:quote[ancestor::cei:cit]"
        mode="tenor" priority="-1">

        <!-- cei:note  -->
        <xsl:if test="self::cei:note">
            <fo:footnote>
                <fo:inline baseline-shift="super" font-size="8pt" font-style="normal">
                    <xsl:number
                        value="count(preceding::cei:cit[ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:note[ancestor::cei:tenor = current()/ancestor::cei:tenor]) + 1"
                    />
                </fo:inline>
                <fo:footnote-body>
                    <fo:block> </fo:block>
                </fo:footnote-body>
            </fo:footnote>
        </xsl:if>

        <!-- cei:quote -->
        <xsl:if test="self::cei:quote">
            <fo:inline font-style="italic">
                <xsl:apply-templates select="* | text()" mode="tenor"/>

                <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
                <xsl:if test="not(ends-with(., ' '))">
                    <xsl:apply-templates
                        select="following-sibling::*[not(preceding::text()[preceding-sibling::* = current()][contains(., ' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                        mode="kleber"/>
                </xsl:if>

                <fo:footnote>
                    <fo:inline baseline-shift="super" font-size="8pt" font-style="normal">
                        <xsl:number
                            value="count(preceding::cei:cit[ancestor::cei:tenor] | preceding::cei:note[ancestor::cei:tenor]) + 1"
                        />
                    </fo:inline>
                    <fo:footnote-body>
                        <fo:block> </fo:block>
                    </fo:footnote-body>
                </fo:footnote>
            </fo:inline>
        </xsl:if>
    </xsl:template>

    <!-- Buchstaben (tenor)   -->
    <xsl:template
        match="
            cei:add[@hand] |
            cei:add[@type] |
            cei:c[@type] |
            cei:corr[@sic and @type] |
            cei:corr[@sic and not(@type)] |
            cei:corr[not(@sic) and @type] |
            cei:damage[attribute()] |
            cei:del[@type] |
            cei:handShift[@hand] |
            cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae')) and attribute()] |
            cei:sic[@corr or not(attribute())] |
            cei:space |
            cei:supplied[@type] |
            cei:unclear[@reason]"
        mode="tenor" priority="-1">

        <!-- cei:add[@hand] -->
        <xsl:if test="self::cei:add[@hand]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:add[@type and not(@hand)] -->
        <xsl:if test="self::cei:add[@type and not(@hand)]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:c[@type] -->
        <xsl:if test="self::cei:c[@type]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:corr[@sic and @type] -->
        <xsl:if test="self::cei:corr[@sic and @type]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:corr[@sic and not(@type)] -->
        <xsl:if test="self::cei:corr[@sic and not(@type)]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:corr[not(@sic) and @type] -->
        <xsl:if test="self::cei:corr[not(@sic) and @type]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:damage[@agent and @extent] tenor -->
        <xsl:if test="self::cei:damage[@agent and @extent]">
            <xsl:text>[...]</xsl:text>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:damage[@agent and not(@extent)] -->
        <xsl:if test="self::cei:damage[@agent and not(@extent)]">

            <xsl:text>[</xsl:text>
            <xsl:apply-templates select="text() | *" mode="tenor"/>
            <xsl:text>]</xsl:text>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:damage [not(@agent) and @extent] -->
        <xsl:if test="self::cei:damage[not(@agent) and @extent]">
            <xsl:text>[...]</xsl:text>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:del[@type] -->
        <xsl:if test="self::cei:del[@type]">

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:handshift[@hand]  -->
        <xsl:if test="self::cei:handShift[@hand]">

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:hi[contains(@rend,'monogrammat') or contains(@rend,'maiusc') or contains(@rend,'elongat') or contains(@rend,'capital') or contains(@rend,'oncia')] -->
        <xsl:if
            test="self::cei:hi[contains(@rend, 'monogrammat') or contains(@rend, 'maiusc') or contains(@rend, 'elongat') or contains(@rend, 'capital') or contains(@rend, 'oncia')]">
            <xsl:apply-templates select="text() | *" mode="tenor"> </xsl:apply-templates>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:hi[not(contains(@rend,'monogrammat') or contains(@rend,'maiusc') or contains(@rend,'elongat') or contains(@rend,'capital') or contains(@rend,'oncia'))] -->
        <xsl:if
            test="self::cei:hi[not(contains(@rend, 'monogrammat') or contains(@rend, 'maiusc') or contains(@rend, 'elongat') or contains(@rend, 'capital') or contains(@rend, 'oncia'))]">
            <xsl:apply-templates select="text() | *" mode="tenor"> </xsl:apply-templates>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:sic[@corr] -->
        <xsl:if test="self::cei:sic[@corr]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:sic[not(attribute())] tenor -->
        <xsl:if test="self::cei:sic[not(attribute())]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:space -->
        <xsl:if test="self::cei:space">
            <xsl:text>***</xsl:text>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:supplied[@type] -->
        <xsl:if test="self::cei:supplied[@type]">
            <xsl:apply-templates select="text() | *" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- cei:unclear[@reason] -->
        <xsl:if test="self::cei:unclear[@reason]">
            <xsl:apply-templates select="text() | *" mode="tenor"/>

            <!-- Test, ob Text und oder Element(e) an aktuellem Knoten kleben -->
            <xsl:if test="not(ends-with(., ' '))">
                <xsl:apply-templates
                    select="following-sibling::*[not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])][not(self::cei:lb[starts-with(following::text()[1],' ')])] | following-sibling::text()[not(matches(substring(., 1, 1), '[\s\.,]'))][not(preceding::text()[preceding-sibling::*/generate-id() = current()/generate-id()][contains(., ' ')])]"
                    mode="kleber"/>
            </xsl:if>

        </xsl:if>

        <!-- Fußnoten -->
        <fo:footnote>

            <fo:inline baseline-shift="super" font-size="8pt" font-style="normal">
                <xsl:number
                    value="
                        count(preceding::cei:space[ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:damage[attribute()][ancestor::cei:tenor = current()/ancestor::cei:tenor] |
                        preceding::cei:sic[@corr or not(attribute())][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:unclear[@reason][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:add[@type][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:c[@type][ancestor::cei:tenor = current()/ancestor::cei:tenor] |
                        preceding::cei:corr[@sic and @type][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:corr[@type and not(@sic)][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:corr[@sic and not(@type)][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:del[@type][ancestor::cei:tenor = current()/ancestor::cei:tenor] |
                        preceding::cei:handShift[@hand][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend, 'litterae elongatae'))][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:add[@hand][ancestor::cei:tenor = current()/ancestor::cei:tenor] | preceding::cei:supplied[attribute()][ancestor::cei:tenor = current()/ancestor::cei:tenor]) + 1"
                    format="a"/>
            </fo:inline>

            <fo:footnote-body>
                <fo:block> </fo:block>
            </fo:footnote-body>
        </fo:footnote>


    </xsl:template>

    <!-- Templates Tenor Ausgabe Text von Elementen, die an Fußbnotenelementen kleben -->

    <!-- text() kleber -->
    <xsl:template match="text()" mode="kleber">
        <xsl:choose>
            <!-- Der folgende Textknoten hat kein Leerzeichen -->
            <xsl:when test="not(contains(., ' '))">
                <xsl:choose>
                    <!-- Der Textknoten endet mit Punkt -->
                    <xsl:when test="ends-with(., '.')">
                        <xsl:copy-of
                            select="cei:prepare_ext(substring-before(cei:prepare(.), '.'), ./ancestor::*)"
                        />
                    </xsl:when>
                    <!-- Der Textknoten endet mit Komma -->
                    <xsl:when test="ends-with(., ',')">
                        <xsl:copy-of
                            select="cei:prepare_ext(substring-before(cei:prepare(.), ','), ./ancestor::*)"
                        />
                    </xsl:when>
                    <!-- Der Textknoten endet mit Semikolon -->
                    <xsl:when test="ends-with(., ';')">
                        <xsl:copy-of
                            select="cei:prepare_ext(substring-before(cei:prepare(.), ';'), ./ancestor::*)"
                        />
                    </xsl:when>
                    <!-- Der Textknoten endet mit Doppelpunkt -->
                    <xsl:when test="ends-with(., ':')">
                        <xsl:copy-of
                            select="cei:prepare_ext(substring-before(cei:prepare(.), ':'), ./ancestor::*)"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- Dem ersten Leerzeichen geht ein Punkt voran -->
            <xsl:when test="ends-with(substring-before(., ' '), '.')">
                <xsl:copy-of
                    select="cei:prepare_ext(substring-before(cei:prepare(.), '.'), ./ancestor::*)"/>
            </xsl:when>
            <!-- Dem ersten Leerzeichen geht ein Komma voran -->
            <xsl:when test="ends-with(substring-before(., ' '), ',')">
                <xsl:copy-of
                    select="cei:prepare_ext(substring-before(cei:prepare(.), ','), ./ancestor::*)"/>
            </xsl:when>
            <!-- Dem ersten Leerzeichen geht ein Semikolon voran -->
            <xsl:when test="ends-with(substring-before(., ' '), ';')">
                <xsl:copy-of
                    select="cei:prepare_ext(substring-before(cei:prepare(.), ';'), ./ancestor::*)"/>
            </xsl:when>
            <!-- Dem ersten Leerzeichen geht ein Doppelpunt voran -->
            <xsl:when test="ends-with(substring-before(., ' '), ':')">
                <xsl:copy-of
                    select="cei:prepare_ext(substring-before(cei:prepare(.), ':'), ./ancestor::*)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of
                    select="cei:prepare_ext(substring-before(cei:prepare(.), ' '), ./ancestor::*)"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- cei:bibl (kleber) -->
    <xsl:template match="cei:bibl" mode="kleber" priority="-1"/>

    <!-- cei:cit (kleber) -->
    <xsl:template match="cei:cit" mode="kleber" priority="-1">
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>

    <!-- cei:damage[not(attribute())] (kleber) -->
    <xsl:template match="cei:damage[not(attribute())]" mode="kleber" priority="-1">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates select="* | text()" mode="tenor"/>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <!-- cei:expan (kleber) -->
    <xsl:template match="cei:expan" mode="kleber" priority="-1">
        <xsl:choose>
            <xsl:when test="contains(./text()[1], 'Iesu')">
                <xsl:apply-templates select="* | text()" mode="tenor"/>
                <xsl:if test="ends-with(./text()[last()], ' ')">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>(</xsl:text>
                <xsl:apply-templates select="* | text()" mode="tenor"/>
                <xsl:text>)</xsl:text>
                <xsl:if test="ends-with(./text()[last()], ' ')">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- cei:foreign (kleber) -->
    <xsl:template match="cei:foreign" mode="kleber" priority="-1">
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>

    <!-- cei:hi not(attribute())] (kleber) -->
    <xsl:template match="cei:hi[not(attribute())]" mode="kleber" priority="-1">
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>

    <!-- cei<:hi[contains(@rend,'monogrammat') or contains(@rend,'maiusc') or contains(@rend,'elongat') or contains(@rend,'capital') or contains(@rend,'oncia')] (kleber) -->
    <xsl:template
        match="cei:hi[contains(@rend, 'monogrammat') or contains(@rend, 'maiusc') or contains(@rend, 'elongat') or contains(@rend, 'capital') or contains(@rend, 'oncia')]"
        mode="kleber" priority="-2">
        <xsl:apply-templates select="text() | *" mode="tenor"> </xsl:apply-templates>
    </xsl:template>

    <!-- cei:hi[not(contains(@rend,'monogrammat') or contains(@rend,'maiusc') or contains(@rend,'elongat') or contains(@rend,'capital') or contains(@rend,'oncia'))] (kleber) -->
    <xsl:template
        match="cei:hi[not(contains(@rend, 'monogrammat') or contains(@rend, 'maiusc') or contains(@rend, 'elongat') or contains(@rend, 'capital') or contains(@rend, 'oncia'))]"
        mode="kleber" priority="-2">
        <xsl:apply-templates select="text() | *" mode="tenor"> </xsl:apply-templates>
    </xsl:template>

    <!-- cei:index (kleber) -->
    <xsl:template match="cei:index" mode="kleber" priority="-1">
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>

    <!-- cei:lb (kleber) -->
    <xsl:template match="cei:lb" mode="kleber" priority="-1">
        <!-- <fo:inline color="red"><xsl:text>=</xsl:text></fo:inline> -->
        <xsl:if test="preceding-sibling::text()[1]">
            <xsl:choose>
                <!-- beides Textknoten; beide Leerzeichen -->
                <xsl:when
                    test="ends-with(preceding::text()[1], ' ') and starts-with(following::text()[1], ' ')">
                    <xsl:text>|</xsl:text>
                </xsl:when>
                <!-- beides Textknoten; erster Leerzeichen, zweiter kein Leerzeichen -->
                <xsl:when
                    test="ends-with(preceding::text()[1], ' ') and matches(substring(following::text()[1], 1, 1), '\S')">
                    <xsl:text>| </xsl:text>
                </xsl:when>
                <!-- beides Textknoten; erster kein Leerzeichen, zweiter Leerzeichen -->
                <xsl:when
                    test="matches(substring(preceding::text()[1], string-length(preceding::text()[1]), 1), '\S') and starts-with(following::text()[1], ' ')">
                    <xsl:text> |</xsl:text>
                </xsl:when>
                <!-- beides Textknoten; erster kein Leerzeichen, zweiter kein Leerzeichen -->
                <xsl:when
                    test="matches(substring(preceding::text()[1], string-length(preceding::text()[1]), 1), '\S') and matches(substring(following::text()[1], 1, 1), '\S')">
                    <xsl:text>|</xsl:text>
                </xsl:when>
                <xsl:otherwise>!!!</xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!-- cei:persName (kleber)-->
    <xsl:template match="cei:persName" mode="kleber" priority="-1">
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>

    <!-- cei:pict (kleber) -->
    <xsl:template match="cei:pict" mode="kleber" priority="-1">
        <xsl:if
            test="not(.[@type = 'signum crucis']/ancestor::cei:damage) and .[@type = 'signum crucis']">
            <xsl:text> + </xsl:text>
        </xsl:if>
        <xsl:if test=".[@type = 'signum crucis']/ancestor::cei:damage">
            <xsl:text>+</xsl:text>
        </xsl:if>
        <xsl:if
            test=".[@type = 'signum notarii' or @type = 'signum iudicis' or @type = 'signum testis' or @type = 'signum auctoris']">
            <xsl:text> (S) </xsl:text>
        </xsl:if>
        <xsl:if test=".[@type = 'monogramma']">
            <xsl:text> (M) </xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- cei:quote[not(ancestor::cei:cit)] (kleber) -->
    <xsl:template match="cei:quote[not(ancestor::cei:cit)]" mode="kleber" priority="-1">
        <fo:inline font-style="italic">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
        </fo:inline>
    </xsl:template>


</xsl:stylesheet>
