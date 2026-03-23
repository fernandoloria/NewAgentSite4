<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                extension-element-prefixes="exsl">
  <xsl:output  method="html" indent="no" encoding="UTF-8" />

  <xsl:template match="//xml">
	<h3 class="page-title">Weekly Balance</h3>
	<ul class="page-breadcrumb breadcrumb"><li><i class="fa fa-home"></i><a href="../Report/Welcome.aspx" target="_self">Home</a><i class="fa fa-angle-right"></i></li><li><a href="#">Weekly Balance</a></li></ul>
    <TABLE CELLSPACING="1" CELLPADDING="1" BORDER="0" class="filter">
      <TR>
        <TD>
          Day Week Date:
		</TD>
        <TD>
          <INPUT TYPE="text" class="form-control datepicker" id="datepicker" NAME="Date1" value="{//xml/@StartDate}" />
        </TD>
        <TD>
          <INPUT type="SUBMIT" class="btn btn-primary"  value="Submit" name="Submit" />
        </TD>
        <TD>
          Transaction Type:
		</TD>
        <TD>
          <SELECT class="form-control form-control-sm"  NAME="cType" OnChange="post();">
            <xsl:for-each select="combobox">
              <OPTION VALUE="{@Value}">
                <xsl:if test="@Selected='1'">
                  <xsl:attribute name="Selected">Selected</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="@Text" />
              </OPTION>
            </xsl:for-each>
          </SELECT>
        </TD>
		<TD></TD>
      </TR>
    </TABLE>
    <CENTER>
      <H4>
        <xsl:value-of select="@StartDate"/> To <xsl:value-of select="@EndDate"/>
      </H4>

      <xsl:if test="@Master='False'">
        <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="100%" class="filter table-bordered">
          <TR CLASS="page-titles">
            <TD class="TdSpace"></TD>
            <TD WIDTH="10%">Player</TD>
            <TD WIDTH="10%" ALIGN="right">BalFwd</TD>
            <TD ALIGN="right">
              <xsl:value-of select="@HeaderDay1"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="@HeaderDay2"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="@HeaderDay3"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="@HeaderDay4"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="@HeaderDay5"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="@HeaderDay6"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="@HeaderDay7"/>
            </TD>
            <TD ALIGN="right">This Week</TD>
            <TD ALIGN="right">Pmts</TD>
            <TD ALIGN="right">Balance</TD>
            <TD ALIGN="right">SettlFig</TD>
            <xsl:if test ="@PaymentRight = 'True'">
              <TD ALIGN="right"></TD>
            </xsl:if>
            <TD class="TdSpace"></TD>
          </TR>
          <xsl:for-each select="//player">
            <TR>
              <xsl:attribute name="class">
                <xsl:choose>
                  <xsl:when test="count(preceding::player) mod 2 = 0">TrGameOdd</xsl:when>
                  <xsl:otherwise>TrGameEven</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <TD class="TdSpace"></TD>
              <TD>
                <xsl:value-of select="@Player"/>-<xsl:value-of select="@Name"/>
              </TD>
              <TD ALIGN="right">
                <xsl:value-of select="format-number(@BalFwd,'###,##0')"/>
              </TD>
              <TD ALIGN="right">
                <xsl:if test="//xml/@DisplayHistoryRight = 'True'">
                  <xsl:choose>
                    <xsl:when test="@CntDay1 != 0">
                      <a href="javascript:GetPlayerHistory({@IdPlayer},'{//xml/@StartDate}',1);">
                        <xsl:value-of select="format-number(@WeekDay1,'###,##0')"/>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="format-number(@WeekDay1,'###,##0')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
                <xsl:if test="//xml/@DisplayHistoryRight = 'False'">
                  <xsl:value-of select="format-number(@WeekDay1,'###,##0')"/>
                </xsl:if>
              </TD>
              <TD ALIGN="right">
                <xsl:if test="//xml/@DisplayHistoryRight = 'True'">
                  <xsl:choose>
                    <xsl:when test="@CntDay2 != 0">
                      <a href="javascript:GetPlayerHistory({@IdPlayer},'{//xml/@StartDate}',2);">
                        <xsl:value-of select="format-number(@WeekDay2,'###,##0')"/>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="format-number(@WeekDay2,'###,##0')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
                <xsl:if test="//xml/@DisplayHistoryRight = 'False'">
                  <xsl:value-of select="format-number(@WeekDay2,'###,##0')"/>
                </xsl:if>
              </TD>
              <TD ALIGN="right">
                <xsl:if test="//xml/@DisplayHistoryRight = 'True'">
                  <xsl:choose>
                    <xsl:when test="@CntDay3 != 0">
                      <a href="javascript:GetPlayerHistory({@IdPlayer},'{//xml/@StartDate}',3);">
                        <xsl:value-of select="format-number(@WeekDay3,'###,##0')"/>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="format-number(@WeekDay3,'###,##0')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
                <xsl:if test="//xml/@DisplayHistoryRight = 'False'">
                  <xsl:value-of select="format-number(@WeekDay3,'###,##0')"/>
                </xsl:if>
              </TD>
              <TD ALIGN="right">
                <xsl:if test="//xml/@DisplayHistoryRight = 'True'">
                  <xsl:choose>
                    <xsl:when test="@CntDay4 != 0">
                      <a href="javascript:GetPlayerHistory({@IdPlayer},'{//xml/@StartDate}',4);">
                        <xsl:value-of select="format-number(@WeekDay4,'###,##0')"/>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="format-number(@WeekDay4,'###,##0')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
                <xsl:if test="//xml/@DisplayHistoryRight = 'False'">
                  <xsl:value-of select="format-number(@WeekDay4,'###,##0')"/>
                </xsl:if>
              </TD>
              <TD ALIGN="right">
                <xsl:if test="//xml/@DisplayHistoryRight = 'True'">
                  <xsl:choose>
                    <xsl:when test="@CntDay5 != 0">
                      <a href="javascript:GetPlayerHistory({@IdPlayer},'{//xml/@StartDate}',5);">
                        <xsl:value-of select="format-number(@WeekDay5,'###,##0')"/>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="format-number(@WeekDay5,'###,##0')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
                <xsl:if test="//xml/@DisplayHistoryRight = 'False'">
                  <xsl:value-of select="format-number(@WeekDay5,'###,##0')"/>
                </xsl:if>
              </TD>
              <TD ALIGN="right">
                <xsl:if test="//xml/@DisplayHistoryRight = 'True'">
                  <xsl:choose>
                    <xsl:when test="@CntDay6 != 0">
                      <a href="javascript:GetPlayerHistory({@IdPlayer},'{//xml/@StartDate}',6);">
                        <xsl:value-of select="format-number(@WeekDay6,'###,##0')"/>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="format-number(@WeekDay6,'###,##0')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
                <xsl:if test="//xml/@DisplayHistoryRight = 'False'">
                  <xsl:value-of select="format-number(@WeekDay6,'###,##0')"/>
                </xsl:if>
              </TD>
              <TD ALIGN="right">
                <xsl:if test="//xml/@DisplayHistoryRight = 'True'">
                  <xsl:choose>
                    <xsl:when test="@CntDay7 != 0">
                      <a href="javascript:GetPlayerHistory({@IdPlayer},'{//xml/@StartDate}',7);">
                        <xsl:value-of select="format-number(@WeekDay7,'###,##0')"/>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="format-number(@WeekDay7,'###,##0')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
                <xsl:if test="//xml/@DisplayHistoryRight = 'False'">
                  <xsl:value-of select="format-number(@WeekDay7,'###,##0')"/>
                </xsl:if>
              </TD>
              <TD ALIGN="right">
                <xsl:value-of select="format-number(@ThisWeek,'###,##0')"/>
              </TD>
              <TD ALIGN="right">
                <xsl:value-of select="format-number(@Ptms,'###,##0')"/>
              </TD>
              <TD ALIGN="right">
                <xsl:value-of select="format-number(@Balance,'###,##0')"/>
              </TD>
              <TD ALIGN="right">
                <xsl:choose>
                  <xsl:when test="(@Balance > @SettleFigure) or ((@Balance * -1) > @SettleFigure)">
                    <xsl:value-of select="format-number(@Balance,'###,##0')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    0
                  </xsl:otherwise>
                </xsl:choose>
              </TD>
              <xsl:if test ="@PaymentRight = 'True'">
                <TD ALIGN="right">
                  <a href="Payments.aspx?Player={@Player}">Request</a>
                </TD>
              </xsl:if>
              <TD class="TdSpace"></TD>
            </TR>
          </xsl:for-each>
          <xsl:if test="count(//player)>0">
            <TR>
              <xsl:attribute name="class">
                <xsl:choose>
                  <xsl:when test="count(//player) mod 2 = 0">TrGameOdd</xsl:when>
                  <xsl:otherwise>TrGameEven</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <TD class="TdSpace"></TD>
              <TD>
                <STRONG>Totals</STRONG>
              </TD>
              <TD ALIGN="right">
                <STRONG>
                  <xsl:value-of select="format-number(//agent/@BalFwd,'###,##0')" />
                </STRONG>
              </TD>
              <TD ALIGN="right">
                <STRONG>
                  <xsl:value-of select="format-number(//agent/@WeekDay1,'###,##0')" />
                </STRONG>
              </TD>
              <TD ALIGN="right">
                <STRONG>
                  <xsl:value-of select="format-number(//agent/@WeekDay2,'###,##0')" />
                </STRONG>
              </TD>
              <TD ALIGN="right">
                <STRONG>
                  <xsl:value-of select="format-number(//agent/@WeekDay3,'###,##0')" />
                </STRONG>
              </TD>
              <TD ALIGN="right">
                <STRONG>
                  <xsl:value-of select="format-number(//agent/@WeekDay4,'###,##0')" />
                </STRONG>
              </TD>
              <TD ALIGN="right">
                <STRONG>
                  <xsl:value-of select="format-number(//agent/@WeekDay5,'###,##0')" />
                </STRONG>
              </TD>
              <TD ALIGN="right">
                <STRONG>
                  <xsl:value-of select="format-number(//agent/@WeekDay6,'###,##0')" />
                </STRONG>
              </TD>
              <TD ALIGN="right">
                <STRONG>
                  <xsl:value-of select="format-number(//agent/@WeekDay7,'###,##0')" />
                </STRONG>
              </TD>
              <TD ALIGN="right">
                <STRONG>
                  <xsl:value-of select="format-number(//agent/@ThisWeek,'###,##0')" />
                </STRONG>
              </TD>
              <TD ALIGN="right">
                <STRONG>
                  <xsl:value-of select="format-number(//agent/@Ptms,'###,##0')" />
                </STRONG>
              </TD>
              <TD ALIGN="right">
                <STRONG>
                  <xsl:value-of select="format-number(//agent/@Balance,'###,##0')" />
                </STRONG>
              </TD>
              <TD ALIGN="right">
                <xsl:call-template name="TotalSettled">
                  <xsl:with-param name="Agent" select="//agent/@Agent" />
                </xsl:call-template>
              </TD>
              <xsl:if test ="@PaymentRight = 'True'">
                <TD ALIGN="right"></TD>
              </xsl:if>
              <TD class="TdSpace"></TD>
            </TR>
            <TR CLASS="TrGameBottom">
              <TD colspan="15" align="center">
                Players Total: <xsl:value-of select="count(//player)"/>
              </TD>
            </TR>
          </xsl:if>

          <xsl:if test="count(//player) = 0">
            <TR CLASS="TrGameBottom">
              <TD colspan="15" align="center">
                0 player with Action.
              </TD>
            </TR>
          </xsl:if>
        </TABLE>
      </xsl:if>

      <xsl:if test="@Master='True'">

        <xsl:for-each select="agent">
          <BR/>
          <xsl:if test="@Distributor='False'">
            <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="100%" >
              <TR CLASS="page-titles">
                <TD class="TdSpace"></TD>
                <TD WIDTH="10%">
                  Agent <xsl:value-of select="@Agent"/>
                </TD>
                <TD WIDTH="10%" ALIGN="right">BalFwd</TD>
                <TD ALIGN="right">
                  <xsl:value-of select="//xml/@HeaderDay1"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="//xml/@HeaderDay2"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="//xml/@HeaderDay3"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="//xml/@HeaderDay4"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="//xml/@HeaderDay5"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="//xml/@HeaderDay6"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="//xml/@HeaderDay7"/>
                </TD>
                <TD ALIGN="right">This Week</TD>
                <TD ALIGN="right">Pmts</TD>
                <TD ALIGN="right">Balance</TD>
                <TD ALIGN="right">SettFig</TD>
                <xsl:if test ="@PaymentRight = 'True'">
                  <TD></TD>
                </xsl:if>
                <TD class="TdSpace"></TD>
              </TR>

              <xsl:for-each select="player">
                <TR>
                  <xsl:attribute name="class">
                    <xsl:choose>
                      <xsl:when test="count(preceding::player) mod 2 = 0">TrGameOdd</xsl:when>
                      <xsl:otherwise>TrGameEven</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <TD class="TdSpace"></TD>
                  <TD>
                    <xsl:value-of select="@Player"/>-<xsl:value-of select="@Name"/>
                  </TD>
                  <TD ALIGN="right">
                    <xsl:value-of select="format-number(@BalFwd,'###,##0')"/>
                  </TD>
                  <TD ALIGN="right">
                    <xsl:if test="//xml/@DisplayHistoryRight = 'True'">
                      <xsl:choose>
                        <xsl:when test="@CntDay1 != 0">
                          <a href="javascript:GetPlayerHistory({@IdPlayer},'{//xml/@StartDate}',1);">
                            <xsl:value-of select="format-number(@WeekDay1,'###,##0')"/>
                          </a>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="format-number(@WeekDay1,'###,##0')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                    <xsl:if test="//xml/@DisplayHistoryRight = 'False'">
                      <xsl:value-of select="format-number(@WeekDay1,'###,##0')"/>
                    </xsl:if>
                  </TD>
                  <TD ALIGN="right">
                    <xsl:if test="//xml/@DisplayHistoryRight = 'True'">
                      <xsl:choose>
                        <xsl:when test="@CntDay2 != 0">
                          <a href="javascript:GetPlayerHistory({@IdPlayer},'{//xml/@StartDate}',2);">
                            <xsl:value-of select="format-number(@WeekDay2,'###,##0')"/>
                          </a>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="format-number(@WeekDay2,'###,##0')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                    <xsl:if test="//xml/@DisplayHistoryRight = 'False'">
                      <xsl:value-of select="format-number(@WeekDay2,'###,##0')"/>
                    </xsl:if>
                  </TD>
                  <TD ALIGN="right">
                    <xsl:if test="//xml/@DisplayHistoryRight = 'True'">
                      <xsl:choose>
                        <xsl:when test="@CntDay3 != 0">
                          <a href="javascript:GetPlayerHistory({@IdPlayer},'{//xml/@StartDate}',3);">
                            <xsl:value-of select="format-number(@WeekDay3,'###,##0')"/>
                          </a>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="format-number(@WeekDay3,'###,##0')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                    <xsl:if test="//xml/@DisplayHistoryRight = 'False'">
                      <xsl:value-of select="format-number(@WeekDay3,'###,##0')"/>
                    </xsl:if>
                  </TD>
                  <TD ALIGN="right">
                    <xsl:if test="//xml/@DisplayHistoryRight = 'True'">
                      <xsl:choose>
                        <xsl:when test="@CntDay4 != 0">
                          <a href="javascript:GetPlayerHistory({@IdPlayer},'{//xml/@StartDate}',4);">
                            <xsl:value-of select="format-number(@WeekDay4,'###,##0')"/>
                          </a>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="format-number(@WeekDay4,'###,##0')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                    <xsl:if test="//xml/@DisplayHistoryRight = 'False'">
                      <xsl:value-of select="format-number(@WeekDay4,'###,##0')"/>
                    </xsl:if>
                  </TD>
                  <TD ALIGN="right">
                    <xsl:if test="//xml/@DisplayHistoryRight = 'True'">
                      <xsl:choose>
                        <xsl:when test="@CntDay5 != 0">
                          <a href="javascript:GetPlayerHistory({@IdPlayer},'{//xml/@StartDate}',5);">
                            <xsl:value-of select="format-number(@WeekDay5,'###,##0')"/>
                          </a>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="format-number(@WeekDay5,'###,##0')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                    <xsl:if test="//xml/@DisplayHistoryRight = 'False'">
                      <xsl:value-of select="format-number(@WeekDay5,'###,##0')"/>
                    </xsl:if>
                  </TD>
                  <TD ALIGN="right">
                    <xsl:if test="//xml/@DisplayHistoryRight = 'True'">
                      <xsl:choose>
                        <xsl:when test="@CntDay6 != 0">
                          <a href="javascript:GetPlayerHistory({@IdPlayer},'{//xml/@StartDate}',6);">
                            <xsl:value-of select="format-number(@WeekDay6,'###,##0')"/>
                          </a>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="format-number(@WeekDay6,'###,##0')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                    <xsl:if test="//xml/@DisplayHistoryRight = 'False'">
                      <xsl:value-of select="format-number(@WeekDay6,'###,##0')"/>
                    </xsl:if>
                  </TD>
                  <TD ALIGN="right">
                    <xsl:if test="//xml/@DisplayHistoryRight = 'True'">
                      <xsl:choose>
                        <xsl:when test="@CntDay7 != 0">
                          <a href="javascript:GetPlayerHistory({@IdPlayer},'{//xml/@StartDate}',7);">
                            <xsl:value-of select="format-number(@WeekDay7,'###,##0')"/>
                          </a>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="format-number(@WeekDay7,'###,##0')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                    <xsl:if test="//xml/@DisplayHistoryRight = 'False'">
                      <xsl:value-of select="format-number(@WeekDay7,'###,##0')"/>
                    </xsl:if>
                  </TD>
                  <TD ALIGN="right">
                    <xsl:value-of select="format-number(@ThisWeek,'###,##0')"/>
                  </TD>
                  <TD ALIGN="right">
                    <xsl:value-of select="format-number(@Ptms,'###,##0')"/>
                  </TD>
                  <TD ALIGN="right">
                    <xsl:value-of select="format-number(@Balance,'###,##0')"/>
                  </TD>
                  <TD ALIGN="right">
                    <xsl:choose>
                      <xsl:when test="(@Balance > @SettleFigure) or ((@Balance * -1) > @SettleFigure)">
                        <xsl:value-of select="format-number(@Balance,'###,##0')"/>
                      </xsl:when>
                      <xsl:otherwise>
                        0
                      </xsl:otherwise>
                    </xsl:choose>
                  </TD>
                  <xsl:if test ="@PaymentRight = 'True'">
                    <TD ALIGN="right">
                      <a href="Payments.aspx?Player={@Player}">Request</a>
                    </TD>
                  </xsl:if>
                  <TD class="TdSpace"></TD>
                </TR>
              </xsl:for-each>

              <TR>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="count(player) mod 2 = 0">TrGameOdd</xsl:when>
                    <xsl:otherwise>TrGameEven</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <TD class="TdSpace"></TD>
                <TD>
                  <STRONG>Agent Totals</STRONG>
                </TD>
                <TD ALIGN="right">
                  <STRONG>
                    <xsl:value-of select="format-number(@BalFwd,'###,##0')" />
                  </STRONG>
                </TD>
                <TD ALIGN="right">
                  <STRONG>
                    <xsl:value-of select="format-number(@WeekDay1,'###,##0')" />
                  </STRONG>
                </TD>
                <TD ALIGN="right">
                  <STRONG>
                    <xsl:value-of select="format-number(@WeekDay2,'###,##0')" />
                  </STRONG>
                </TD>
                <TD ALIGN="right">
                  <STRONG>
                    <xsl:value-of select="format-number(@WeekDay3,'###,##0')" />
                  </STRONG>
                </TD>
                <TD ALIGN="right">
                  <STRONG>
                    <xsl:value-of select="format-number(@WeekDay4,'###,##0')" />
                  </STRONG>
                </TD>
                <TD ALIGN="right">
                  <STRONG>
                    <xsl:value-of select="format-number(@WeekDay5,'###,##0')" />
                  </STRONG>
                </TD>
                <TD ALIGN="right">
                  <STRONG>
                    <xsl:value-of select="format-number(@WeekDay6,'###,##0')" />
                  </STRONG>
                </TD>
                <TD ALIGN="right">
                  <STRONG>
                    <xsl:value-of select="format-number(@WeekDay7,'###,##0')" />
                  </STRONG>
                </TD>
                <TD ALIGN="right">
                  <STRONG>
                    <xsl:value-of select="format-number(@ThisWeek,'###,##0')" />
                  </STRONG>
                </TD>
                <TD ALIGN="right">
                  <STRONG>
                    <xsl:value-of select="format-number(@Ptms,'###,##0')" />
                  </STRONG>
                </TD>
                <TD ALIGN="right">
                  <STRONG>
                    <xsl:value-of select="format-number(@Balance,'###,##0')" />
                  </STRONG>
                </TD>
                <TD ALIGN="right">
                  <xsl:call-template name="TotalSettled" >
                    <xsl:with-param name="Agent" select="@Agent" />
                  </xsl:call-template>
                </TD>
                <xsl:if test ="@PaymentRight = 'True'">
                  <TD ALIGN="right"></TD>
                </xsl:if>
              </TR>
              <TD class="TdSpace"></TD>
              <TR CLASS="TrGameBottom">
                <TD colspan="15" align="center">
                  Players Total: <xsl:value-of select="count(player)"/>
                </TD>
              </TR>
            </TABLE>
          </xsl:if>

          <xsl:if test="@Distributor='True'">
            <TABLE CELLSPACING="0" CELLPADDING="1" BORDER="0" WIDTH="100%" >
              <TR CLASS="page-titles">
                <TD class="TdSpace"></TD>
                <TD WIDTH="10%">
                  Distributor <xsl:value-of select="@Agent"/>
                </TD>
                <TD WIDTH="10%" ALIGN="right">BalFwd</TD>
                <TD ALIGN="right">
                  <xsl:value-of select="//xml/@HeaderDay1"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="//xml/@HeaderDay2"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="//xml/@HeaderDay3"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="//xml/@HeaderDay4"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="//xml/@HeaderDay5"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="//xml/@HeaderDay6"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="//xml/@HeaderDay7"/>
                </TD>
                <TD ALIGN="right">This Week</TD>
                <TD ALIGN="right">Pmts</TD>
                <TD ALIGN="right">Balance</TD>
                <TD></TD>
                <xsl:if test ="@PaymentRight = 'True'">
                  <TD></TD>
                </xsl:if>
                <TD class="TdSpace"></TD>
              </TR>
              <TR>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="count(//agent)+1 mod 2 = 0">TrGameOdd</xsl:when>
                    <xsl:otherwise>TrGameEven</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <TD>No Players</TD>
                <TD ALIGN="right" colspan="14"></TD>
              </TR>
              <TR CLASS="TrGameBottom">
                <TD colspan="15"></TD>
              </TR>
            </TABLE>

          </xsl:if>

        </xsl:for-each>
        <BR/>
        <TABLE CELLSPACING="0" CELLPADDING="1" BORDER="0" WIDTH="100%" >
          <TR CLASS="page-titles">
            <TD class="TdSpace"></TD>
            <TD WIDTH="10%">Master Totals</TD>
            <TD WIDTH="10%" ALIGN="right">BalFwd</TD>
            <TD ALIGN="right">
              <xsl:value-of select="@HeaderDay1"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="@HeaderDay2"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="@HeaderDay3"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="@HeaderDay4"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="@HeaderDay5"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="@HeaderDay6"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="@HeaderDay7"/>
            </TD>
            <TD ALIGN="right">This Week</TD>
            <TD ALIGN="right">Pmts</TD>
            <TD ALIGN="right">Balance</TD>
            <TD></TD>
            <xsl:if test ="@PaymentRight = 'True'">
              <TD></TD>
            </xsl:if>
            <TD class="TdSpace"></TD>
          </TR>
          <TR>
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="count(preceding::agent) mod 2 = 0">TrGameOdd</xsl:when>
                <xsl:otherwise>TrGameEven</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <TD class="TdSpace"></TD>
            <TD>
              <xsl:value-of select="@Agent"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="format-number(sum(//agent/@BalFwd),'###,##0')"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="format-number(sum(//agent/@WeekDay1),'###,##0')"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="format-number(sum(//agent/@WeekDay2),'###,##0')"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="format-number(sum(//agent/@WeekDay3),'###,##0')"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="format-number(sum(//agent/@WeekDay4),'###,##0')"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="format-number(sum(//agent/@WeekDay5),'###,##0')"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="format-number(sum(//agent/@WeekDay6),'###,##0')"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="format-number(sum(//agent/@WeekDay7),'###,##0')"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="format-number(sum(//agent/@ThisWeek),'###,##0')"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="format-number(sum(//agent/@Ptms),'###,##0')"/>
            </TD>
            <TD ALIGN="right">
              <xsl:value-of select="format-number(sum(//agent/@Balance),'###,##0')"/>
            </TD>
            <TD></TD>
            <xsl:if test ="@PaymentRight = 'True'">
              <TD></TD>
            </xsl:if>
            <TD class="TdSpace"></TD>
          </TR>
          <TR CLASS="TrGameBottom">
            <TD colspan="16" align ="center">
              Players Total: <xsl:value-of select="count(//player)"/> -
              Win/Loss Total: <xsl:value-of select="format-number(number(sum(//player/@WeekDay1) + sum(//player/@WeekDay2) + sum(//player/@WeekDay3) + sum(//player/@WeekDay4) + sum(//player/@WeekDay5) + sum(//player/@WeekDay6) + sum(//player/@WeekDay7)),'###,##0')" />
            </TD>
          </TR>
        </TABLE>

      </xsl:if>
    </CENTER>


  </xsl:template>

  <xsl:template name="TotalSettled">
    <xsl:param name="Agent" />
    <root>
      <xsl:variable name="tmpTotal">
        <total_amount>
          <xsl:for-each select="//xml//agent[@Agent = $Agent]//player">
            <item>
              <xsl:choose>
                <xsl:when test="(@Balance > @SettleFigure) or ((@Balance * -1) > @SettleFigure)">
                  <xsl:value-of select="@Balance"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="0"/>
                </xsl:otherwise>
              </xsl:choose>
            </item>
          </xsl:for-each>
        </total_amount>
      </xsl:variable>

      <total>
        <xsl:variable name="SettTotal" select="exsl:node-set($tmpTotal)" />
        <xsl:value-of select="format-number(sum($SettTotal/total_amount/item),'###,##0')"/>
      </total>
    </root>
  </xsl:template>  
  
</xsl:stylesheet>
