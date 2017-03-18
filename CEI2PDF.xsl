<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xrx="http://www.monasterium.net/NS/xrx" xmlns:cei="http://www.monasterium.net/NS/cei"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:atom="http://www.w3.org/2005/Atom"
    version="3.0" id="charter2pdf">
    <xsl:preserve-space elements="*"/>
    <xsl:output indent="yes"/>


    <!-- Leerzeichen aus Elementen rausziehen (löschen und zwischen Elemente schreiben) -->
    <!-- Input Urkunden // XML-Dateien -->
    <xsl:variable name="newText"
        select="parse-xml(replace(unparsed-text('./CVU6_02.03.17.xml'), '([\S]) (&lt;/[^>]*?>&lt;[^>]*?>)', '$1$2 '))"/>

    <!-- Wurzelknoten -->
    <xsl:template match="/">
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

                    <xsl:for-each select="$newText//atom:entry">

                        <!-- Variable für Fußnotenkörper-->
                        <xsl:variable name="footnote">

                            <!-- Buchstaben -->
                            <fo:block line-height-shift-adjustment="disregard-shifts"
                                line-height="1.5em" space-after="5mm">

                                <xsl:for-each
                                    select="
                                        //cei:tenor//cei:add[@hand and not(@type)] |
                                        //cei:tenor//cei:add[@type and not(@hand)] |
                                        //cei:tenor//cei:add[@type and @hand] |
                                        //cei:tenor//cei:c[@type] |
                                        //cei:tenor//cei:corr[@type and @sic] |
                                        //cei:tenor//cei:corr[@type and not(@sic)] |
                                        //cei:tenor//cei:corr[not(@type) and @sic] |
                                        //cei:tenor//cei:damage[attribute()] |
                                        //cei:tenor//cei:del[@type] |
                                        //cei:tenor//cei:handShift[@hand] |
                                        //cei:tenor//cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend,'litterae elongatae'))] |
                                        //cei:tenor//cei:sic[@corr or not(attribute())] |
                                        //cei:tenor//cei:space |
                                        //cei:tenor//cei:supplied[@type] |
                                        //cei:tenor//cei:unclear[@reason]
                                        ">

                                    <fo:inline baseline-shift="super" font-size="8pt">
                                        <xsl:number value="position()" format="a"/>
                                    </fo:inline>
                                    <xsl:text> </xsl:text>

                                    <!-- cei:add[@hand] -->
                                    <xsl:if test="self::cei:add[@hand and not(@type)]">
                                        <xsl:apply-templates select="* | text()" mode="tenor"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:analyze-string select="@hand" regex="/\w?[^/]*\w?/">
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
                                    </xsl:if>

                                    <!-- cei:add[@type] -->
                                    <xsl:if test="self::cei:add[@type and not(@hand)]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
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
                                    </xsl:if>

                                    <!-- cei:add[@type] -->
                                    <xsl:if test="self::cei:add[@type and @hand]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
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
                                        <xsl:analyze-string select="@hand" regex="/\w?[^/]*\w?/">
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
                                    </xsl:if>

                                    <!-- cei:c[@type] -->
                                    <xsl:if test="self::cei:c[@type]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
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
                                                  test="not(ends-with(text()[1]/preceding::text()[1], ' ')) and not(starts-with(text()/following::text()[1], ' '))">
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
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of select="."/>
                                                </fo:inline>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:damage[not(@agent) and @extent] -->
                                    <xsl:if test="self::cei:damage[not(@agent) and @extent]">
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
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of select="."/>
                                                </fo:inline>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:damage[@agent) and @extent] -->
                                    <xsl:if test="self::cei:damage[@agent and @extent]">
                                        <xsl:analyze-string select="@agent" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of select="."/>
                                                </fo:inline>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                        <xsl:analyze-string select="@extent" regex="/\w?[^/]*\w?/">
                                            <xsl:matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after(., '/'), '/')"
                                                  />
                                                </fo:inline>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <fo:inline font-style="italic">
                                                  <xsl:value-of select="."/>
                                                </fo:inline>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:if>

                                    <!-- cei:del[@type] -->
                                    <xsl:if test="self::cei:del[@type]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
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
                                    </xsl:if>

                                    <!-- cei:handShift[@hand] -->
                                    <xsl:if test="self::cei:handShift[@hand]">
                                        <xsl:analyze-string select="@hand" regex="/\w?[^/]*\w?/">
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
                                    </xsl:if>

                                    <!-- cei:hi[contains(not(contains(@rend, 'in nesso monogrammatico'))] -->
                                    <xsl:if
                                        test="self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend,'litterae elongatae'))]">
                                        <xsl:apply-templates select="* | text()" mode="tenor"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:analyze-string select="@rend" regex="/\w?[^/]*\w?/">
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
                                    </xsl:if>

                                    <!-- cei:sic[@corr] -->
                                    <xsl:if test="self::cei:sic[@corr]">
                                        <fo:inline font-style="italic">
                                            <xsl:text>Così in </xsl:text>
                                        </fo:inline>
                                        <xsl:text>A, </xsl:text>
                                        <xsl:analyze-string select="@corr" regex="/\w?[^/]*\w?/">
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
                                    </xsl:if>

                                    <!-- cei:sic[not(attribute())] -->
                                    <xsl:if test="self::cei:sic[not(attribute())]">
                                        <fo:inline font-style="italic">
                                            <xsl:text>Così in</xsl:text>
                                        </fo:inline>
                                        <xsl:text> A.</xsl:text>
                                    </xsl:if>

                                    <!-- cei:space -->
                                    <xsl:if test="self::cei:space">
                                        <fo:inline font-style="italic">
                                            <xsl:text>Segue spazio lasciato in bianco </xsl:text>
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
                                    </xsl:if>

                                    <!-- cei:supplied[@type] -->
                                    <xsl:if test="self::cei:supplied[@type]">
                                        <xsl:analyze-string select="@type" regex="/\w?[^/]*\w?/">
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
                                        //cei:tenor//cei:bibl[ancestor::cei:cit] |
                                        //cei:tenor//cei:note">

                                    <fo:inline baseline-shift="super" font-size="8pt">
                                        <xsl:number value="position()"/>
                                    </fo:inline>
                                    <xsl:text> </xsl:text>

                                    <!-- cei:bibl[ancestor::cei:cit] -->
                                    <xsl:if test="self::cei:bibl[ancestor::cei:cit]">
                                        <xsl:analyze-string select="." regex="/\w?[^/]*\w?/">
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
                                        <xsl:if
                                            test="not(ends-with(normalize-space(.), '.')) and not(ends-with(normalize-space(.), './'))">
                                            <xsl:text>.</xsl:text>
                                        </xsl:if>
                                    </xsl:if>

                                    <!-- cei:note -->
                                    <xsl:if test="self::cei:note">
                                        <xsl:apply-templates/>
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
        <xsl:if test="//cei:issued">
            <fo:block text-align="center" keep-with-next.within-page="always">

                <!-- Datum -->
                <xsl:apply-templates
                    select="//cei:issued/cei:date/text() | //cei:issued/cei:dateRange/text()"
                    mode="normalized"/>

                <!-- Test auf Vorkommen von Datum und Ort -->
                <xsl:if
                    test="//cei:issued/cei:date/text() and //cei:issued/cei:placeName/text() or //cei:issued/cei:dateRange/text() and //cei:issued/cei:placeName/text()">
                    <xsl:text>, </xsl:text>
                </xsl:if>

                <!-- Ort -->
                <xsl:apply-templates select="//cei:issued/cei:placeName/text()"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "abstract" (Zusammenafssung der Urkunde) -->
    <xsl:template name="abstract">
        <xsl:if test="//cei:abstract">
            <fo:block text-align="justify" text-indent="10mm">
                <xsl:apply-templates
                    select="//cei:abstract/text() | //cei:abstract//cei:foreign | //cei:abstract//cei:quote"
                />
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "wittness" (Quelle der Urkunde) -->
    <xsl:template name="wittnes">
        <!-- Fall 1: Es ist ein Original -->
        <xsl:if test="//cei:witnessOrig/cei:traditioForm/text()">
            <fo:block text-indent="10mm" text-align="justify" margin-top="5mm" font-size="10pt">

                <xsl:value-of select="normalize-space(//cei:witnessOrig/cei:traditioForm/text())"/>
                <xsl:text>, </xsl:text>
                <!-- reichen die Elemente witnessOrig und traditioForm oder muss der Inhalt getestet werden? -->

                <!-- <cei:idno> -->
                <xsl:if test="//cei:witnessOrig/cei:archIdentifier/cei:idno/text()">
                    <xsl:value-of
                        select="concat('BSNSP ', //cei:witnessOrig/cei:archIdentifier/cei:idno[1]/text())"
                    />
                </xsl:if>
                <xsl:if test="//cei:witnessOrig/cei:traditioForm/text()">
                    <xsl:text> [A]</xsl:text>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="//cei:witListPar//cei:traditioForm">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>. </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:for-each select="//cei:witListPar/cei:witness">
                    <xsl:value-of select=".//cei:traditioForm"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select=".//cei:repository"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select=".//cei:idno"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="concat('[', ./@n, ']')"/>
                </xsl:for-each>
                <xsl:text>. </xsl:text>

                <!-- Achtung: Datum ausgeben. Steht am Ende von archidentifier -->

                <!-- cei:rubrum -->
                <xsl:apply-templates select="//cei:witnessOrig/cei:rubrum"/>

                <!-- cei:nota -->
                <xsl:apply-templates select="//cei:witnessOrig/cei:nota"/>

            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "edition" (Edition) -->
    <xsl:template name="edition">
        <!-- Problem, es werden Leerzeichen produziert -->
        <xsl:if test="//cei:diplomaticAnalysis/cei:listBiblEdition/cei:bibl/text()">
            <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
                <xsl:text>Ed. </xsl:text>
                <xsl:apply-templates select="//cei:diplomaticAnalysis/cei:listBiblEdition/cei:bibl"/>
                <!-- Link auf Monasterium-Seite einfügen: http://monasterium.net/mom/smg-EV/SMG_2_AA_I_5/charter -->
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "facsimile" -->
    <xsl:template name="facsimile">
        <xsl:if test="//cei:diplomaticAnalysis/cei:listBiblFaksimile/cei:bibl/text()">
            <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
                <xsl:text>Facs. </xsl:text>
                <xsl:apply-templates
                    select="//cei:diplomaticAnalysis/cei:listBiblFaksimile/cei:bibl"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "regest" -->
    <xsl:template name="regest">
        <xsl:if test="//cei:diplomaticAnalysis/cei:listBiblRegest/cei:bibl/text()">
            <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
                <xsl:text>Reg. </xsl:text>
                <xsl:apply-templates select="//cei:diplomaticAnalysis/cei:listBiblRegest/cei:bibl"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "physicalDesc" -->
    <xsl:template name="physicalDesc">
        <xsl:if test="//cei:witnessOrig/cei:physicalDesc//text()">
            <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
                <xsl:apply-templates
                    select="//cei:witnessOrig/cei:physicalDesc/cei:condition/text()"
                    mode="normalized"/>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="//cei:witnessOrig/cei:physicalDesc/cei:material/text()"
                    mode="normalized"/>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="//cei:witnessOrig/cei:auth/cei:sealDesc/text()"
                    mode="normalized"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Template "misura" -->
    <xsl:template name="misura">
        <xsl:if test="//cei:witnessOrig/cei:physicalDesc/cei:dimensions/text()">
            <fo:block text-indent="10mm" text-align="justify" font-size="10pt">
                <xsl:text>Misura </xsl:text>
                <xsl:apply-templates
                    select="//cei:witnessOrig/cei:physicalDesc/cei:dimensions/text()"/>
                <xsl:text>. </xsl:text>
                <xsl:apply-templates select="//cei:p[(position() = 1)]" mode="erstes"/>
            </fo:block>
            <xsl:apply-templates select="//cei:p[not(position() = 1)]" mode="mittlere"
            > </xsl:apply-templates>
        </xsl:if>
    </xsl:template>


    <!-- Templates Metadaten Ausgabe Text  -->

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
        <xsl:apply-templates select="//cei:pTenor"/>
    </xsl:template>


    <!-- Templates Tenor -->

    <!-- Templates aufrufen für cei:pTenor -->
    <xsl:template match="//cei:pTenor">
        <xsl:if test="//cei:tenor/cei:pTenor/text()">
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
                    or preceding-sibling::node()[1][self::cei:hi[contains(@rend, 'in nesso monogrammatico')]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:hi[contains(@rend, 'in nesso monogrammatico')]]]
                    or preceding-sibling::node()[1][self::cei:sic[@corr or not(attribute())]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:sic[@corr or not(attribute())]]]
                    or preceding-sibling::node()[1][self::cei:space] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:space]]
                    or preceding-sibling::node()[1][self::cei:supplied[@type]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:supplied[@type]]]
                    or preceding-sibling::node()[1][self::cei:unclear[@reason]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:unclear[@reason]]]
                    
                    or preceding-sibling::node()[1][self::cei:note] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:note]]
                    or preceding-sibling::node()[1][self::cei:quote[ancestor::cei:cit]] or preceding-sibling::node()[1][self::cei:lb][preceding-sibling::node()[1][self::cei:quote[ancestor::cei:cit]]]
                    
                    )
                    ">
                <xsl:choose>
                    <xsl:when test="ends-with(substring-before(., ' '), ',')">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="substring-after(., ' ')"/>
                    </xsl:when>
                    <xsl:when test="ends-with(substring-before(., ' '), '.')">
                        <xsl:text>. </xsl:text>
                        <xsl:value-of select="substring-after(., ' ')"/>
                    </xsl:when>
                    <xsl:when test="ends-with(substring-before(., ' '), ':')">
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="substring-after(., ' ')"/>
                    </xsl:when>
                    <xsl:when test="ends-with(substring-before(., ' '), ';')">
                        <xsl:text>; </xsl:text>
                        <xsl:value-of select="substring-after(., ' ')"/>
                    </xsl:when>
                    <xsl:when test=". = '.' or . = ',' or . = ':' or . = ';'">
                        <xsl:value-of select="."/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <!-- Ausgabe Textknoten, die Teil eines Zitates (cei:quote) sind -->
                            <xsl:when test="ancestor::cei:quote">
                                <xsl:text xml:space="preserve"> </xsl:text>
                                <xsl:value-of select="substring-after(., ' ')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat(' ', substring-after(., ' '))"/>
                            </xsl:otherwise>
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
                        <xsl:value-of select="substring-after(., ' ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
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
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>

    <!-- cei:damage[not(attribute())] (tenor) -->
    <xsl:template match="cei:damage[not(attribute())]" mode="tenor" priority="-1">
        <xsl:if
            test="not(preceding-sibling::node()[1][self::cei:unclear][not(ends-with(., ' '))]) and not(starts-with(., ' '))">
            <xsl:text>[</xsl:text>
            <xsl:apply-templates select="* | text()" mode="tenor"/>
            <xsl:text>]</xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- cei:expan (tenor) -->
    <xsl:template match="cei:expan" mode="tenor" priority="-1">
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

    <!-- cei:foreign (tenor) -->
    <xsl:template match="cei:foreign" mode="tenor" priority="-1">
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>

    <!-- cei:hi not(attribute())] (tenor) -->
    <xsl:template match="cei:hi[not(attribute())]" mode="tenor" priority="-1">
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>

    <!-- cei:hi[@rend='litterae elongatae' or @rend='lettere maiuscole'] (tenor)-->
    <xsl:template match="cei:hi[@rend = 'litterae elongatae' or @rend = 'lettere maiuscole']"
        mode="tenor" priority="-1">
        <xsl:apply-templates select="text() | cei:expan" mode="sc"> </xsl:apply-templates>
    </xsl:template>

    <!-- cei:index (tenor) -->
    <xsl:template match="cei:index" mode="tenor" priority="-1">
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>

    <!-- cei:lb (tenor) -->
    <xsl:template match="cei:lb" mode="tenor" priority="-1">
        <xsl:if test="preceding-sibling::text()[1]">
            <xsl:choose>
                <xsl:when test="preceding-sibling::node()[1][self::cei:damage]"/>
                <!-- Test: Knoten davor und danach auf Leerzeichen prüfen  -->
                <xsl:when
                    test="matches(substring(following::text()[1], 1, 1), '[A-Z]') or ends-with(preceding::text()[1], ' ') and not(ancestor::cei:quote)">
                    <xsl:text>| </xsl:text>
                </xsl:when>
                <xsl:when
                    test="matches(substring(following::text()[1], 1, 1), ' ') or ends-with(preceding::text()[1], ' ') and not(ancestor::cei:quote)">
                    <xsl:text> |</xsl:text>
                </xsl:when>
                <xsl:when
                    test="matches(substring(following::text()[1], 1, 1), '[A-Z]') or ends-with(preceding::text()[1], ' ') and ancestor::cei:quote">
                    <xsl:text>|</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>|</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!-- cei:persName (tenor)-->
    <xsl:template match="cei:persName" mode="tenor" priority="-1">
        <xsl:apply-templates select="* | text()" mode="tenor"/>
    </xsl:template>

    <!-- cei:pict (tenor) -->
    <xsl:template match="cei:pict" mode="tenor" priority="-1">
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

    <!-- cei:quote[not(ancestor::cei:cit)] (tenor) -->
    <xsl:template match="cei:quote[not(ancestor::cei:cit)]" mode="tenor" priority="-1">
        <fo:inline font-style="italic">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
        </fo:inline>
    </xsl:template>

    <!-- Temlates Tenor (small caps: sc) -->

    <!-- text() (sc) -->
    <xsl:template match="text()" mode="sc" priority="-1">
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
    </xsl:template>

    <!-- cei:expan (sc) -->
    <xsl:template match="cei:expan" mode="sc" priority="-1">
        <xsl:choose>
            <xsl:when test="contains(./text()[1], 'Iesu')">
                <xsl:analyze-string select="." regex="[A-Z]">
                    <xsl:matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <fo:inline font-style="normal" font-size="75%">
                            <xsl:text/>
                            <xsl:value-of select="upper-case(.)"/>
                            <xsl:text/>
                        </fo:inline>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>(</xsl:text>
                <xsl:analyze-string select="." regex="[A-Z]">
                    <xsl:matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <fo:inline font-style="normal" font-size="75%">
                            <xsl:text/>
                            <xsl:value-of select="upper-case(.)"/>
                            <xsl:text/>
                        </fo:inline>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
                <xsl:text>)</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="ends-with(./text()[last()], ' ')">
            <xsl:text> </xsl:text>
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
                        value="count(preceding::cei:cit[ancestor::cei:tenor] | preceding::cei:note[ancestor::cei:tenor]) + 1"
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
                <fo:footnote>
                    <fo:inline baseline-shift="super" font-size="8pt" font-style="normal">
                        <xsl:number
                            value="count(preceding::cei:cit[ancestor::cei:tenor] | preceding::cei:note[ancestor::cei:tenor]) + 1"/>
                        <xsl:if
                            test="ancestor::cei:cit/following-sibling::*[not(starts-with(text()[1], '.')) and not(starts-with(text()[1], ',')) and not(starts-with(text()[1], ';')) and not(starts-with(text()[1], ':')) and not(starts-with(text()[1], ' '))]">
                            <xsl:text xml:space="preserve"> </xsl:text>
                        </xsl:if>
                        <!--<xsl:if
                            test="not(starts-with(following::text()[1], '.')) and not(starts-with(following::text()[1], ',')) and not(starts-with(following::text()[1], ';')) and not(starts-with(following::text()[1], ':')) and not(starts-with(following::text()[1], ' '))">
                            <xsl:text xml:space="preserve"> </xsl:text>
                        </xsl:if>-->
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
            cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend,'litterae elongatae'))] |
            cei:sic[@corr or not(attribute())] |
            cei:space |
            cei:supplied[@type] |
            cei:unclear[@reason]"
        mode="tenor" priority="-1">

        <!-- cei:add[@hand] -->
        <xsl:if test="self::cei:add[@hand]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
            <xsl:if
                test="not(starts-with(following-sibling::text()[1], ' ')) and not(ends-with(., ' '))">
                <xsl:choose>
                    <xsl:when
                        test="ends-with(substring-before(following-sibling::text()[1], ' '), ',')">
                        <xsl:value-of select="substring-before(following-sibling::text()[1], ',')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Achtung: geändert -->
                        <xsl:value-of select="substring-before(following::text()[1], ' ')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <!-- cei:add[@type and not(@hand)] -->
        <xsl:if test="self::cei:add[@type and not(@hand)]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
            <xsl:if
                test="not(starts-with(following-sibling::text()[1], ' ')) and not(ends-with(., ' '))">
                <xsl:choose>
                    <xsl:when
                        test="ends-with(substring-before(following-sibling::text()[1], ' '), ',')">
                        <xsl:value-of select="substring-before(following-sibling::text()[1], ',')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-before(following-sibling::text()[1], ' ')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <!-- cei:c[@type] -->
        <xsl:if test="self::cei:c[@type]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
            <xsl:if
                test="not(starts-with(following-sibling::text()[1], ' ')) and not(ends-with(., ' '))">
                <xsl:choose>
                    <xsl:when
                        test="ends-with(substring-before(following-sibling::text()[1], ' '), ',')">
                        <xsl:value-of select="substring-before(following-sibling::text()[1], ',')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains(following-sibling::text()[1], ' ')">
                                <xsl:value-of
                                    select="substring-before(following-sibling::text()[1], ' ')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="following-sibling::text()[1]"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <!-- cei:corr[@sic and @type] -->
        <xsl:if test="self::cei:corr[@sic and @type]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
            <xsl:if
                test="not(starts-with(following-sibling::text()[1], ' ')) and not(ends-with(., ' '))">
                <xsl:choose>
                    <xsl:when
                        test="ends-with(substring-before(following-sibling::text()[1], ' '), ',')">
                        <xsl:value-of select="substring-before(following-sibling::text()[1], ',')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-before(following-sibling::text()[1], ' ')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <!-- cei:corr[@sic and not(@type)] -->
        <xsl:if test="self::cei:corr[@sic and not(@type)]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
            <xsl:if
                test="not(starts-with(following-sibling::text()[1], ' ')) and not(ends-with(., ' '))">
                <xsl:choose>
                    <xsl:when
                        test="ends-with(substring-before(following-sibling::text()[1], ' '), ',')">
                        <xsl:value-of select="substring-before(following-sibling::text()[1], ',')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-before(following-sibling::text()[1], ' ')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <!-- cei:corr[not(@sic) and @type] -->
        <xsl:if test="self::cei:corr[not(@sic) and @type]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
            <xsl:if
                test="not(starts-with(following-sibling::text()[1], ' ')) and not(ends-with(., ' '))">
                <xsl:choose>
                    <xsl:when
                        test="ends-with(substring-before(following-sibling::text()[1], ' '), ',')">
                        <xsl:value-of select="substring-before(following-sibling::text()[1], ',')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="contains(following-sibling::text()[1], ' ')">
                            <xsl:value-of
                                select="substring-before(following-sibling::text()[1], ' ')"/>
                        </xsl:if>
                        <xsl:if test="not(contains(following-sibling::text()[1], ' '))">
                            <xsl:value-of select="following-sibling::text()[1]"/>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <!-- cei:damage[@agent and @extent] tenor -->
        <xsl:if test="self::cei:damage[@agent and @extent]">
            <xsl:if test="not(text())">
                <xsl:choose>
                    <xsl:when
                        test="not(starts-with(following-sibling::text()[1], ' ')) and not(ends-with(., ' '))">
                        <xsl:text>[...]</xsl:text>
                        <xsl:choose>
                            <xsl:when
                                test="ends-with(substring-before(following-sibling::text()[1], ' '), ',')">
                                <xsl:value-of
                                    select="substring-before(following-sibling::text()[1], ',')"/>
                            </xsl:when>
                            <xsl:when
                                test="ends-with(substring-before(following-sibling::text()[1], ' '), '.')">
                                <xsl:value-of
                                    select="substring-before(following-sibling::text()[1], '.')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="contains(following-sibling::text()[1], ' ')">
                                        <xsl:value-of
                                            select="substring-before(following-sibling::text()[1], ' ')"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="following-sibling::text()[1]"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>[</xsl:text>
                        <xsl:apply-templates select="text() | *" mode="tenor"/>
                        <xsl:text>]</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <!-- cei:damage[@agent and not(@extent)] -->
        <xsl:if test="self::cei:damage[@agent and not(@extent)]">
            <xsl:choose>
                <xsl:when
                    test="not(starts-with(following-sibling::text()[1], ' ')) and not(ends-with(., ' '))">
                    <xsl:text>[</xsl:text>
                    <xsl:apply-templates select="text() | *" mode="tenor"/>
                    <xsl:text>]</xsl:text>
                    <xsl:choose>
                        <xsl:when
                            test="ends-with(substring-before(following-sibling::text()[1], ' '), ',')">
                            <xsl:if test="following-sibling::node()[1][self::cei:lb]">|</xsl:if>
                            <xsl:value-of
                                select="substring-before(following-sibling::text()[1], ',')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="contains(following-sibling::text()[1], ' ')">
                                    <xsl:if test="following-sibling::node()[1][self::cei:lb]"
                                        >|</xsl:if>
                                    <xsl:value-of
                                        select="substring-before(following-sibling::text()[1], ' ')"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="following-sibling::node()[1][self::cei:lb]"
                                        >|</xsl:if>
                                    <xsl:value-of select="following-sibling::text()[1]"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>[</xsl:text>
                    <xsl:apply-templates select="text() | *" mode="tenor"/>
                    <xsl:text>]</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <!-- cei:damage [not(@agent) and @extent] -->
        <xsl:if test="self::cei:damage[not(@agent) and @extent]">
            <xsl:if test="not(text())">
                <xsl:choose>
                    <xsl:when
                        test="not(starts-with(following-sibling::text()[1], ' ')) and not(ends-with(., ' '))">
                        <xsl:text>[...]</xsl:text>
                        <xsl:choose>
                            <xsl:when
                                test="ends-with(substring-before(following-sibling::text()[1], ' '), ',')">
                                <xsl:value-of
                                    select="substring-before(following-sibling::text()[1], ',')"/>
                            </xsl:when>
                            <xsl:when
                                test="ends-with(substring-before(following-sibling::text()[1], ' '), '.')">
                                <xsl:value-of
                                    select="substring-before(following-sibling::text()[1], '.')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="contains(following-sibling::text()[1], ' ')">
                                        <xsl:value-of
                                            select="substring-before(following-sibling::text()[1], ' ')"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="following-sibling::text()[1]"/>
                                    </xsl:otherwise>
                                </xsl:choose>

                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>[...</xsl:text>
                        <xsl:apply-templates select="text() | *" mode="tenor"/>
                        <xsl:text>]</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <!-- self::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend,'litterae elongatae'))]  -->
        <xsl:if test="self::cei:hi[not(contains(@rend, 'Test1'))]">
            <xsl:analyze-string select="text()" regex="[A-Z]">
                <xsl:matching-substring>
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <fo:inline font-style="normal" font-size="75%">
                        <xsl:value-of select="upper-case(normalize-space(.))"/>
                    </fo:inline>
                    <xsl:text>&#x200D;</xsl:text>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:if>

        <!-- cei:sic[@corr] -->
        <xsl:if test="self::cei:sic[@corr]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
        </xsl:if>

        <!-- cei:sic[not(attribute())] tenor -->
        <xsl:if test="self::cei:sic[not(attribute())]">
            <xsl:apply-templates select="* | text()" mode="tenor"/>
        </xsl:if>

        <!-- cei:space -->
        <xsl:if test="self::cei:space">
            <xsl:text>***</xsl:text>
        </xsl:if>

        <!-- cei:supplied[@type] -->
        <xsl:if test="self::cei:supplied[@type]">
            <xsl:choose>
                <xsl:when
                    test="not(starts-with(following-sibling::text()[1], ' ')) and not(ends-with(., ' '))">
                    <xsl:text>[</xsl:text>
                    <xsl:apply-templates select="text() | *" mode="tenor"/>
                    <xsl:text>]</xsl:text>
                    <xsl:choose>
                        <xsl:when
                            test="ends-with(substring-before(following-sibling::text()[1], ' '), ',')">
                            <xsl:value-of
                                select="substring-before(following-sibling::text()[1], ',')"/>
                        </xsl:when>
                        <xsl:when
                            test="ends-with(substring-before(following-sibling::text()[1], ' '), '.')">
                            <xsl:value-of
                                select="substring-before(following-sibling::text()[1], '.')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="contains(following-sibling::text()[1], ' ')">
                                    <xsl:value-of
                                        select="substring-before(following-sibling::text()[1], ' ')"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="following-sibling::text()[1]"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>[</xsl:text>
                    <xsl:apply-templates select="text() | *" mode="tenor"/>
                    <xsl:text>]</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <!-- cei:unclear[@reason] -->
        <xsl:if test="self::cei:unclear[@reason]">
            <xsl:apply-templates select="text() | *" mode="tenor"/>
            <!-- Test, ob Text an Element klebt -->
            <xsl:if
                test="not(starts-with(following-sibling::text()[1], ' ')) and not(ends-with(., ' '))">
                <xsl:choose>
                    <xsl:when
                        test="ends-with(substring-before(following-sibling::text()[1], ' '), ',')">
                        <xsl:value-of select="substring-before(following-sibling::text()[1], ',')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-before(following-sibling::text()[1], ' ')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <!-- Test, ob Element an Element klebt -->
            <xsl:if
                test="not(starts-with(following-sibling::*[1]/text()[1], ' ')) and not(ends-with(., ' ')) and following-sibling::node()[1][self::element()]">
                <xsl:choose>
                    <xsl:when
                        test="ends-with(substring-before(following-sibling::text()[1], ' '), ',')">
                        <xsl:value-of select="substring-before(following-sibling::text()[1], ',')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="following-sibling::*[1]" mode="kleber"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>

        <!-- Fußnoten -->
        <fo:footnote>

            <fo:inline baseline-shift="super" font-size="8pt" font-style="normal">
                <xsl:number
                    value="
                        count(preceding::cei:space[ancestor::cei:tenor] | preceding::cei:damage[attribute()][ancestor::cei:tenor] |
                        preceding::cei:sic[@corr or not(attribute())] | preceding::cei:unclear[@reason] | preceding::cei:add[@type] | preceding::cei:c[@type] |
                        preceding::cei:corr[@sic and @type] | preceding::cei:corr[@type and not(@sic)] | preceding::cei:corr[@sic and not(@type)] | preceding::cei:del[@type] |
                        preceding::cei:handShift[@hand] | preceding::cei:hi[not(contains(@rend, 'lettere maiuscole') or contains(@rend,'litterae elongatae'))] | preceding::cei:add[@hand]) + 1"
                    format="a"/>
            </fo:inline>

            <fo:footnote-body>
                <fo:block> </fo:block>
            </fo:footnote-body>
        </fo:footnote>
        

    </xsl:template>

    <!-- Templates Tenor Ausgabe Text von Elementen, die an Fußbnotenelementen kleben -->

    <!-- cei:damage[not(attribute())] tenor -->
    <xsl:template match="cei:damage[not(attribute())]" mode="kleber" priority="-1">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates select="* | text()" mode="tenor"/>
        <xsl:text>]</xsl:text>
    </xsl:template>


</xsl:stylesheet>
